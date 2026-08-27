//
//  auth.routes.ts
//  RiseServer
//
//  Fastify authentication routes
//

import { FastifyInstance } from 'fastify';
import { AuthService } from './auth.service.js';
import { AuthController } from './auth.controller.js';
import {
  registerSchema,
  loginSchema,
  appleAuthSchema,
  googleAuthSchema,
  refreshTokenSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  appleWebhookSchema,
  sendOtpSchema,
  verifyOtpSchema,
} from './auth.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function authRoutes(fastify: FastifyInstance) {
  const authService = new AuthService();
  const authController = new AuthController(authService);

  fastify.post(
    '/send-otp',
    {
      schema: {
        description: 'Generate and send a 6-digit email verification OTP',
        tags: ['Authentication'],
        body: sendOtpSchema,
      },
    },
    authController.sendOtp.bind(authController)
  );

  fastify.post(
    '/verify-otp',
    {
      schema: {
        description: 'Verify 6-digit email OTP code',
        tags: ['Authentication'],
        body: verifyOtpSchema,
      },
    },
    authController.verifyOtp.bind(authController)
  );

  fastify.post(
    '/register',
    {
      schema: {
        description: 'Register a new user with email and password',
        tags: ['Authentication'],
        body: registerSchema,
      },
    },
    authController.register.bind(authController)
  );

  fastify.post(
    '/login',
    {
      schema: {
        description: 'Log in an existing user with email and password',
        tags: ['Authentication'],
        body: loginSchema,
      },
    },
    authController.login.bind(authController)
  );

  fastify.post(
    '/apple',
    {
      schema: {
        description: 'Authenticate or sign up using Sign in with Apple',
        tags: ['Authentication'],
        body: appleAuthSchema,
      },
    },
    authController.appleAuth.bind(authController)
  );

  fastify.post(
    '/google',
    {
      schema: {
        description: 'Authenticate or sign up using Google Sign-In',
        tags: ['Authentication'],
        body: googleAuthSchema,
      },
    },
    authController.googleAuth.bind(authController)
  );

  fastify.post(
    '/refresh',
    {
      schema: {
        description: 'Rotate refresh token and retrieve a fresh JWT access token',
        tags: ['Authentication'],
        body: refreshTokenSchema,
      },
    },
    authController.refresh.bind(authController)
  );

  fastify.post(
    '/forgot-password',
    {
      schema: {
        description: 'Request a password reset link (generates 15-minute token)',
        tags: ['Authentication'],
        body: forgotPasswordSchema,
      },
    },
    authController.forgotPassword.bind(authController)
  );

  fastify.post(
    '/reset-password',
    {
      schema: {
        description: 'Reset password with token and revoke all active sessions',
        tags: ['Authentication'],
        body: resetPasswordSchema,
      },
    },
    authController.resetPassword.bind(authController)
  );

  fastify.get(
    '/sessions',
    {
      preHandler: [authenticate],
      schema: {
        description: 'List all active multi-device sessions for the user',
        tags: ['Authentication'],
        security: [{ bearerAuth: [] }],
      },
    },
    authController.getSessions.bind(authController)
  );

  fastify.delete(
    '/sessions/:id',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Remotely revoke a specific active device session',
        tags: ['Authentication'],
        security: [{ bearerAuth: [] }],
        params: z.object({
          id: z.string().uuid(),
        }),
      },
    },
    authController.revokeSession.bind(authController)
  );

  fastify.delete(
    '/sessions/other',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Log out of all other active device sessions',
        tags: ['Authentication'],
        security: [{ bearerAuth: [] }],
      },
    },
    authController.revokeAllOtherSessions.bind(authController)
  );

  fastify.post(
    '/apple-webhook',
    {
      schema: {
        description: 'Apple Server-to-Server notification webhook for revocation events',
        tags: ['Authentication'],
        body: appleWebhookSchema,
      },
    },
    authController.appleWebhook.bind(authController)
  );
}
