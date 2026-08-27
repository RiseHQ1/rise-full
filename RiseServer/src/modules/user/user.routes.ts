//
//  user.routes.ts
//  RiseServer
//
//  Fastify user profile and account routes
//

import { FastifyInstance } from 'fastify';
import { UserService } from './user.service.js';
import { UserController } from './user.controller.js';
import { updateProfileSchema, changePasswordSchema } from './user.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';

export async function userRoutes(fastify: FastifyInstance) {
  const userService = new UserService();
  const userController = new UserController(userService);

  fastify.addHook('preHandler', authenticate);

  fastify.get(
    '/me',
    {
      schema: {
        description: 'Get profile and routine preferences for the authenticated user',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
      },
    },
    userController.getMe.bind(userController)
  );

  fastify.patch(
    '/me',
    {
      schema: {
        description: 'Update profile details or notification routine times',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
        body: updateProfileSchema,
      },
    },
    userController.updateMe.bind(userController)
  );

  fastify.put(
    '/profile',
    {
      schema: {
        description: 'Update user profile and onboarding preferences',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
        body: updateProfileSchema,
      },
    },
    userController.updateMe.bind(userController)
  );

  fastify.patch(
    '/profile',
    {
      schema: {
        description: 'Update user profile and onboarding preferences',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
        body: updateProfileSchema,
      },
    },
    userController.updateMe.bind(userController)
  );

  fastify.post(
    '/change-password',
    {
      schema: {
        description: 'Change user password',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
        body: changePasswordSchema,
      },
    },
    userController.changePassword.bind(userController)
  );

  fastify.get(
    '/export',
    {
      schema: {
        description: 'Export complete user data archive for GDPR/CCPA compliance',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
      },
    },
    userController.exportData.bind(userController)
  );

  fastify.delete(
    '/account',
    {
      schema: {
        description: 'Permanently delete user account and all personal data (Apple Guideline 5.1.1(v))',
        tags: ['User'],
        security: [{ bearerAuth: [] }],
      },
    },
    userController.deleteAccount.bind(userController)
  );
}
