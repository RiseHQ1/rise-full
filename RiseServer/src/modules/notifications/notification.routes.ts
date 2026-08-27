//
//  notification.routes.ts
//  RiseServer
//
//  Notification device token routes
//

import { FastifyInstance } from 'fastify';
import { NotificationService } from './notification.service.js';
import { NotificationController } from './notification.controller.js';
import { registerDeviceTokenSchema } from './notification.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function notificationRoutes(fastify: FastifyInstance) {
  const notificationService = new NotificationService();
  const notificationController = new NotificationController(notificationService);

  fastify.addHook('preHandler', authenticate);

  fastify.post(
    '/device-token',
    {
      schema: {
        description: 'Register or update an APNs device token for the current user',
        tags: ['Notifications'],
        security: [{ bearerAuth: [] }],
        body: registerDeviceTokenSchema,
      },
    },
    notificationController.registerToken.bind(notificationController)
  );

  fastify.delete(
    '/device-token',
    {
      schema: {
        description: 'Unregister an APNs device token on logout',
        tags: ['Notifications'],
        security: [{ bearerAuth: [] }],
        body: z.object({ token: z.string().min(1) }),
      },
    },
    notificationController.unregisterToken.bind(notificationController)
  );
}
