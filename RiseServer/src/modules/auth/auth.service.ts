//
//  auth.service.ts
//  RiseServer
//
//  Authentication business logic (Email/Password, Apple Sign-In, Password Reset, Apple Revocation)
//

import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';
import { hashPassword, verifyPassword, generateSecureToken, sha256 } from '@/utils/crypto.js';
import { RegisterInput, LoginInput, AppleAuthInput, ResetPasswordInput } from './auth.schema.js';
import { logger } from '@/utils/logger.js';
import { EmailService } from '@/services/email/email.service.js';

export class AuthService {
  private emailService = new EmailService();

  /**
   * Generate 6-digit OTP code, save in Redis for 10 minutes, and dispatch via email.
   */
  async generateAndSendOTP(email: string, name?: string): Promise<{ success: boolean; message: string }> {
    const cleanEmail = email.toLowerCase().trim();
    // Generate 6-digit random code
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Store in Redis with 600s (10 min) TTL
    await redis.setex(`otp:${cleanEmail}`, 600, otpCode);
    logger.info({ email: cleanEmail, otpCode }, 'Generated verification OTP code');

    await this.emailService.sendOTPEmail(cleanEmail, name || 'Friend', otpCode);
    return { success: true, message: 'Verification code sent successfully' };
  }

  /**
   * Verify provided OTP code against Redis store.
   */
  async verifyOTP(email: string, code: string): Promise<{ verified: boolean }> {
    const cleanEmail = email.toLowerCase().trim();
    const storedCode = await redis.get(`otp:${cleanEmail}`);

    if (!storedCode) {
      throw { statusCode: 400, code: 'OTP_EXPIRED', message: 'Verification code has expired or does not exist' };
    }

    if (storedCode !== code.trim()) {
      throw { statusCode: 400, code: 'INVALID_OTP', message: 'Invalid verification code. Please check and try again.' };
    }

    // Delete once verified
    await redis.del(`otp:${cleanEmail}`);
    logger.info({ email: cleanEmail }, 'Email OTP successfully verified');
    return { verified: true };
  }

  /**
   * Register a new user with Email and Password.
   */
  async registerWithEmail(input: RegisterInput, ipAddress?: string, userAgent?: string) {
    const existing = await prisma.user.findUnique({
      where: { email: input.email.toLowerCase() },
    });

    if (existing) {
      throw { statusCode: 409, code: 'EMAIL_ALREADY_EXISTS', message: 'An account with this email already exists' };
    }

    const passwordHash = await hashPassword(input.password);

    const user = await prisma.user.create({
      data: {
        email: input.email.toLowerCase(),
        passwordHash,
        name: input.name,
        authProvider: 'EMAIL',
        userProgress: {
          create: {
            currentStreak: 0,
            bestStreak: 0,
            mindfulMinutes: 0,
          },
        },
      },
    });

    const tokens = await this.generateTokens(user.id, user.subscriptionTier, ipAddress, userAgent);

    return {
      user: this.sanitizeUser(user),
      tokens,
    };
  }

  /**
   * Log in an existing user with Email and Password.
   */
  async loginWithEmail(input: LoginInput, ipAddress?: string, userAgent?: string) {
    const user = await prisma.user.findUnique({
      where: { email: input.email.toLowerCase() },
    });

    if (!user || !user.passwordHash) {
      throw { statusCode: 401, code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' };
    }

    const isValid = await verifyPassword(input.password, user.passwordHash);
    if (!isValid) {
      throw { statusCode: 401, code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' };
    }

    const tokens = await this.generateTokens(user.id, user.subscriptionTier, ipAddress, userAgent);

    return {
      user: this.sanitizeUser(user),
      tokens,
    };
  }

  /**
   * Authenticate or register a user using Sign in with Apple.
   */
  async authenticateWithApple(input: AppleAuthInput, ipAddress?: string, userAgent?: string) {
    let user = await prisma.user.findUnique({
      where: { appleUserId: input.appleUserId },
    });

    if (!user) {
      if (input.email) {
        user = await prisma.user.findUnique({
          where: { email: input.email.toLowerCase() },
        });

        if (user) {
          user = await prisma.user.update({
            where: { id: user.id },
            data: { appleUserId: input.appleUserId },
          });
        }
      }

      if (!user) {
        user = await prisma.user.create({
          data: {
            appleUserId: input.appleUserId,
            email: input.email?.toLowerCase(),
            name: input.name || 'Friend',
            authProvider: 'APPLE',
            isEmailVerified: true,
            userProgress: {
              create: {
                currentStreak: 0,
                bestStreak: 0,
                mindfulMinutes: 0,
              },
            },
          },
        });
      }
    }

    const tokens = await this.generateTokens(user.id, user.subscriptionTier, ipAddress, userAgent);

    return {
      user: this.sanitizeUser(user),
      tokens,
    };
  }

  /**
   * Rotate a Refresh Token and generate a fresh Token Pair.
   * Includes OAuth 2.0 BCP Token Reuse Detection.
   */
  async rotateRefreshToken(rawRefreshToken: string, ipAddress?: string, userAgent?: string) {
    const tokenHash = sha256(rawRefreshToken);

    const storedToken = await prisma.refreshToken.findUnique({
      where: { tokenHash },
      include: { user: true },
    });

    if (!storedToken) {
      throw { statusCode: 401, code: 'INVALID_REFRESH_TOKEN', message: 'Refresh token is invalid' };
    }

    // Reuse detection: If a revoked token is presented, compromise is assumed
    if (storedToken.isRevoked) {
      logger.warn({ userId: storedToken.userId }, '🚨 Token reuse detected! Revoking all sessions for security.');
      await prisma.refreshToken.updateMany({
        where: { userId: storedToken.userId },
        data: { isRevoked: true },
      });
      throw { statusCode: 401, code: 'TOKEN_REUSE_DETECTED', message: 'Security alert: Token reuse detected. Please log in again.' };
    }

    if (storedToken.expiresAt < new Date()) {
      throw { statusCode: 401, code: 'EXPIRED_REFRESH_TOKEN', message: 'Refresh token has expired' };
    }

    await prisma.refreshToken.update({
      where: { id: storedToken.id },
      data: { isRevoked: true },
    });

    const tokens = await this.generateTokens(storedToken.user.id, storedToken.user.subscriptionTier, ipAddress, userAgent);

    return {
      user: this.sanitizeUser(storedToken.user),
      tokens,
    };
  }

  /**
   * Initiate Forgot Password flow by generating a 15-minute reset token.
   */
  async forgotPassword(email: string) {
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });

    if (!user) {
      // Don't leak user existence for security
      return { message: 'If an account with this email exists, a password reset link has been sent.' };
    }

    const rawToken = generateSecureToken(32);
    const tokenHash = sha256(rawToken);

    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15); // 15-min expiry

    await prisma.passwordResetToken.create({
      data: {
        userId: user.id,
        tokenHash,
        expiresAt,
      },
    });

    // Send transactional HTML email
    await this.emailService.sendPasswordResetEmail(user.email || email, user.name, rawToken);

    logger.info({ userId: user.id, email: user.email }, 'Generated password reset token and sent email');
    return {
      message: 'If an account with this email exists, a password reset link has been sent.',
      debugToken: process.env.NODE_ENV === 'development' ? rawToken : undefined,
    };
  }

  /**
   * Reset user password and revoke all existing sessions for security.
   */
  async resetPassword(input: ResetPasswordInput) {
    const tokenHash = sha256(input.token);

    const record = await prisma.passwordResetToken.findUnique({
      where: { tokenHash },
      include: { user: true },
    });

    if (!record || record.isUsed || record.expiresAt < new Date()) {
      throw { statusCode: 400, code: 'INVALID_RESET_TOKEN', message: 'Password reset token is invalid or has expired' };
    }

    const newHash = await hashPassword(input.newPassword);

    await prisma.$transaction([
      prisma.user.update({
        where: { id: record.userId },
        data: { passwordHash: newHash },
      }),
      prisma.passwordResetToken.update({
        where: { id: record.id },
        data: { isUsed: true },
      }),
      // Revoke all active sessions
      prisma.refreshToken.updateMany({
        where: { userId: record.userId },
        data: { isRevoked: true },
      }),
    ]);

    logger.info({ userId: record.userId }, 'Password reset successfully and existing sessions revoked');
    return { message: 'Password has been reset successfully. Please log in with your new password.' };
  }

  /**
   * Handle Apple Server-to-Server notification webhook (consent-revoked, account-delete).
   */
  async processAppleRevocationWebhook(appleUserId: string, eventType: string) {
    logger.info({ appleUserId, eventType }, '🍎 Processing Apple Server-to-Server Revocation');

    const user = await prisma.user.findUnique({
      where: { appleUserId },
    });

    if (user) {
      await prisma.refreshToken.updateMany({
        where: { userId: user.id },
        data: { isRevoked: true },
      });
      await prisma.deviceToken.updateMany({
        where: { userId: user.id },
        data: { isActive: false },
      });
    }

    return { status: 'PROCESSED' };
  }

  /**
   * List active sessions for the user.
   */
  async listSessions(userId: string) {
    return prisma.refreshToken.findMany({
      where: {
        userId,
        isRevoked: false,
        expiresAt: { gt: new Date() },
      },
      select: {
        id: true,
        deviceId: true,
        userAgent: true,
        ipAddress: true,
        createdAt: true,
        expiresAt: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Revoke a specific active session.
   */
  async revokeSession(userId: string, sessionId: string) {
    await prisma.refreshToken.updateMany({
      where: { id: sessionId, userId },
      data: { isRevoked: true },
    });

    return { message: 'Session revoked successfully' };
  }

  /**
   * Revoke all other active sessions for security.
   */
  async revokeAllOtherSessions(userId: string) {
    await prisma.refreshToken.updateMany({
      where: { userId },
      data: { isRevoked: true },
    });

    return { message: 'All other sessions have been logged out' };
  }

  /**
   * Helper to generate Access and Refresh tokens.
   */
  private async generateTokens(userId: string, subscriptionTier: string, ipAddress?: string, userAgent?: string) {
    const rawRefreshToken = generateSecureToken(48);
    const tokenHash = sha256(rawRefreshToken);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 30);

    await prisma.refreshToken.create({
      data: {
        userId,
        tokenHash,
        ipAddress,
        userAgent,
        expiresAt,
      },
    });

    return {
      refreshToken: rawRefreshToken,
      expiresAt: expiresAt.toISOString(),
    };
  }

  /**
   * Strip sensitive fields from user response.
   */
  public sanitizeUser(user: {
    id: string;
    email: string | null;
    name: string;
    avatarUrl: string | null;
    focusAreas?: string[];
    onboardingComplete?: boolean;
    timeZone: string;
    role?: 'USER' | 'CURATOR' | 'ADMIN';
    morningBoostTime: string;
    eveningReflectionTime: string;
    focusDurationMinutes: number;
    motivationStyle: string;
    subscriptionTier: string;
    isEmailVerified?: boolean;
    createdAt: Date;
  }) {
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      focusAreas: user.focusAreas || ['Mindfulness', 'Focus'],
      onboardingComplete: user.onboardingComplete ?? false,
      timeZone: user.timeZone,
      role: user.role || 'USER',
      morningBoostTime: user.morningBoostTime,
      eveningReflectionTime: user.eveningReflectionTime,
      focusDurationMinutes: user.focusDurationMinutes,
      motivationStyle: user.motivationStyle,
      subscriptionTier: user.subscriptionTier,
      isEmailVerified: user.isEmailVerified ?? false,
      createdAt: user.createdAt.toISOString(),
    };
  }
}
