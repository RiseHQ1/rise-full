//
//  user.service.ts
//  RiseServer
//
//  User profile management and App Store compliance account purge
//

import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';
import { hashPassword, verifyPassword } from '@/utils/crypto.js';
import { UpdateProfileInput, ChangePasswordInput } from './user.schema.js';

export class UserService {
  /**
   * Get user profile details with current progress stats.
   */
  async getProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        userProgress: true,
      },
    });

    if (!user) {
      throw { statusCode: 404, code: 'USER_NOT_FOUND', message: 'User account not found' };
    }

    return {
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatarUrl,
      focusAreas: user.focusAreas,
      onboardingComplete: user.onboardingComplete,
      timeZone: user.timeZone,
      morningBoostTime: user.morningBoostTime,
      eveningReflectionTime: user.eveningReflectionTime,
      focusDurationMinutes: user.focusDurationMinutes,
      motivationStyle: user.motivationStyle,
      notificationsEnabled: user.notificationsEnabled,
      subscriptionTier: user.subscriptionTier,
      subscriptionExpiresAt: user.subscriptionExpiresAt?.toISOString() || null,
      createdAt: user.createdAt.toISOString(),
      progress: user.userProgress
        ? {
            currentStreak: user.userProgress.currentStreak,
            bestStreak: user.userProgress.bestStreak,
            mindfulMinutes: user.userProgress.mindfulMinutes,
            reflectionCount: user.userProgress.reflectionCount,
            focusCount: user.userProgress.focusCount,
          }
        : null,
    };
  }

  /**
   * Update user profile, focus areas, and notification routine preferences.
   */
  async updateProfile(userId: string, input: UpdateProfileInput) {
    const updated = await prisma.user.update({
      where: { id: userId },
      data: {
        ...(input.name && { name: input.name }),
        ...(input.avatarUrl !== undefined && { avatarUrl: input.avatarUrl }),
        ...(input.focusAreas && { focusAreas: input.focusAreas }),
        ...(input.onboardingComplete !== undefined && { onboardingComplete: input.onboardingComplete }),
        ...(input.timeZone && { timeZone: input.timeZone }),
        ...(input.morningBoostTime && { morningBoostTime: input.morningBoostTime }),
        ...(input.eveningReflectionTime && { eveningReflectionTime: input.eveningReflectionTime }),
        ...(input.focusDurationMinutes && { focusDurationMinutes: input.focusDurationMinutes }),
        ...(input.motivationStyle && { motivationStyle: input.motivationStyle }),
        ...(input.notificationsEnabled !== undefined && { notificationsEnabled: input.notificationsEnabled }),
      },
      include: { userProgress: true },
    });

    return this.getProfile(updated.id);
  }

  /**
   * Change user password.
   */
  async changePassword(userId: string, input: ChangePasswordInput) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || !user.passwordHash) {
      throw { statusCode: 400, code: 'CANNOT_CHANGE_PASSWORD', message: 'Password cannot be changed for this account' };
    }

    const isMatch = await verifyPassword(input.currentPassword, user.passwordHash);
    if (!isMatch) {
      throw { statusCode: 400, code: 'INVALID_CURRENT_PASSWORD', message: 'Current password is incorrect' };
    }

    const newHash = await hashPassword(input.newPassword);
    await prisma.user.update({
      where: { id: userId },
      data: { passwordHash: newHash },
    });

    return { message: 'Password updated successfully' };
  }

  /**
   * Export complete user data archive for GDPR/CCPA data portability compliance.
   */
  async exportUserData(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        userProgress: true,
        journalEntries: {
          where: { isDeleted: false },
          orderBy: { clientCreatedAt: 'desc' },
        },
        savedContents: {
          where: { isDeleted: false },
          orderBy: { clientUpdatedAt: 'desc' },
        },
        dailyIntentions: {
          where: { isDeleted: false },
          orderBy: { clientUpdatedAt: 'desc' },
        },
        packProgress: {
          include: { pack: true },
        },
      },
    });

    if (!user) {
      throw { statusCode: 404, code: 'USER_NOT_FOUND', message: 'User not found' };
    }

    return {
      exportedAt: new Date().toISOString(),
      account: {
        id: user.id,
        email: user.email,
        name: user.name,
        focusAreas: user.focusAreas,
        onboardingComplete: user.onboardingComplete,
        timeZone: user.timeZone,
        morningBoostTime: user.morningBoostTime,
        eveningReflectionTime: user.eveningReflectionTime,
        motivationStyle: user.motivationStyle,
        createdAt: user.createdAt.toISOString(),
      },
      progress: user.userProgress,
      journals: user.journalEntries,
      savedContent: user.savedContents,
      intentions: user.dailyIntentions,
      packProgress: user.packProgress,
    };
  }

  /**
   * Complete account deletion (Mandated by Apple App Store Review Guideline 5.1.1(v)).
   * Immediately purges all user data, tokens, journal records, and cloud saves.
   */
  async deleteAccount(userId: string) {
    await prisma.user.delete({
      where: { id: userId },
    });

    // Purge any transient Redis quota keys for this user
    const today = new Date().toISOString().slice(0, 10);
    await redis.del(`ai_quota:${userId}:${today}`).catch(() => null);

    return { message: 'Account and associated data have been permanently deleted' };
  }
}
