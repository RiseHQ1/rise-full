//
//  auth.controller.ts
//  RiseServer
//
//  Authentication request handler
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { AuthService } from './auth.service.js';
import { RegisterInput, LoginInput, AppleAuthInput, RefreshTokenInput, ForgotPasswordInput, ResetPasswordInput, AppleWebhookInput } from './auth.schema.js';
import { successResponse } from '@/utils/response.js';

export class AuthController {
  constructor(private authService: AuthService) {}

  async register(request: FastifyRequest<{ Body: RegisterInput }>, reply: FastifyReply) {
    const ip = request.ip;
    const userAgent = request.headers['user-agent'];

    const result = await this.authService.registerWithEmail(request.body, ip, userAgent);
    const accessToken = await reply.jwtSign({
      userId: result.user.id,
      email: result.user.email || undefined,
      role: result.user.role,
      subscriptionTier: result.user.subscriptionTier,
    });

    return reply.status(201).send(
      successResponse({
        user: result.user,
        tokens: {
          accessToken,
          ...result.tokens,
        },
      })
    );
  }

  async login(request: FastifyRequest<{ Body: LoginInput }>, reply: FastifyReply) {
    const ip = request.ip;
    const userAgent = request.headers['user-agent'];

    const result = await this.authService.loginWithEmail(request.body, ip, userAgent);
    const accessToken = await reply.jwtSign({
      userId: result.user.id,
      email: result.user.email || undefined,
      role: result.user.role,
      subscriptionTier: result.user.subscriptionTier,
    });

    return reply.status(200).send(
      successResponse({
        user: result.user,
        tokens: {
          accessToken,
          ...result.tokens,
        },
      })
    );
  }

  async appleAuth(request: FastifyRequest<{ Body: AppleAuthInput }>, reply: FastifyReply) {
    const ip = request.ip;
    const userAgent = request.headers['user-agent'];

    const result = await this.authService.authenticateWithApple(request.body, ip, userAgent);
    const accessToken = await reply.jwtSign({
      userId: result.user.id,
      email: result.user.email || undefined,
      role: result.user.role,
      subscriptionTier: result.user.subscriptionTier,
    });

    return reply.status(200).send(
      successResponse({
        user: result.user,
        tokens: {
          accessToken,
          ...result.tokens,
        },
      })
    );
  }

  async refresh(request: FastifyRequest<{ Body: RefreshTokenInput }>, reply: FastifyReply) {
    const ip = request.ip;
    const userAgent = request.headers['user-agent'];

    const result = await this.authService.rotateRefreshToken(request.body.refreshToken, ip, userAgent);
    const accessToken = await reply.jwtSign({
      userId: result.user.id,
      email: result.user.email || undefined,
      role: result.user.role,
      subscriptionTier: result.user.subscriptionTier,
    });

    return reply.status(200).send(
      successResponse({
        user: result.user,
        tokens: {
          accessToken,
          ...result.tokens,
        },
      })
    );
  }

  async forgotPassword(request: FastifyRequest<{ Body: ForgotPasswordInput }>, reply: FastifyReply) {
    const result = await this.authService.forgotPassword(request.body.email);
    return reply.status(200).send(successResponse(result));
  }

  async resetPassword(request: FastifyRequest<{ Body: ResetPasswordInput }>, reply: FastifyReply) {
    const result = await this.authService.resetPassword(request.body);
    return reply.status(200).send(successResponse(result));
  }

  async getSessions(request: FastifyRequest, reply: FastifyReply) {
    const sessions = await this.authService.listSessions(request.user.userId);
    return reply.status(200).send(successResponse(sessions));
  }

  async revokeSession(request: FastifyRequest, reply: FastifyReply) {
    const params = request.params as { id: string };
    const result = await this.authService.revokeSession(request.user.userId, params.id);
    return reply.status(200).send(successResponse(result));
  }

  async revokeAllOtherSessions(request: FastifyRequest, reply: FastifyReply) {
    const result = await this.authService.revokeAllOtherSessions(request.user.userId);
    return reply.status(200).send(successResponse(result));
  }

  async appleWebhook(request: FastifyRequest<{ Body: AppleWebhookInput }>, reply: FastifyReply) {
    // Process Apple Server-to-Server notification
    return reply.status(200).send(successResponse({ status: 'PROCESSED' }));
  }
}
