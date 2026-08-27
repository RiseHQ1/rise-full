//
//  subscription.routes.ts
//  RiseServer
//
//  RevenueCat subscription routes
//

import { FastifyInstance } from 'fastify';
import { SubscriptionService } from './subscription.service.js';
import { SubscriptionController } from './subscription.controller.js';
import { revenueCatEventSchema } from './subscription.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';

export async function subscriptionRoutes(fastify: FastifyInstance) {
  const subscriptionService = new SubscriptionService();
  const subscriptionController = new SubscriptionController(subscriptionService);

  // Public webhook endpoint for RevenueCat events
  fastify.post(
    '/revenuecat-webhook',
    {
      schema: {
        description: 'Webhook endpoint receiving real-time subscription events from RevenueCat',
        tags: ['Subscriptions'],
        body: revenueCatEventSchema,
      },
    },
    subscriptionController.handleWebhook.bind(subscriptionController)
  );

  // Authenticated user status check
  fastify.get(
    '/status',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Get active subscription tier and Pro entitlement status for the current user',
        tags: ['Subscriptions'],
        security: [{ bearerAuth: [] }],
      },
    },
    subscriptionController.getStatus.bind(subscriptionController)
  );
}
