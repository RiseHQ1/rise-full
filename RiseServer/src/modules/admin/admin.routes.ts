//
//  admin.routes.ts
//  RiseServer
//
//  Administrative management routes with RBAC protection
//

import { FastifyInstance } from 'fastify';
import { AdminService } from './admin.service.js';
import { AdminController } from './admin.controller.js';
import {
  createAdminQuoteSchema,
  updateAdminQuoteSchema,
  listQuotesAdminQuerySchema,
  createAdminPackSchema,
  updateAdminPackSchema,
  createAdminAffirmationSchema,
  updateAdminAffirmationSchema,
  listAffirmationsAdminQuerySchema,
  listUsersAdminQuerySchema,
  updateUserSubscriptionAdminSchema,
  broadcastPushSchema,
} from './admin.schema.js';
import { authenticate, requireRole } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function adminRoutes(fastify: FastifyInstance) {
  const adminService = new AdminService();
  const adminController = new AdminController(adminService);

  // Enforce both JWT authentication AND Admin role verification across all admin routes
  fastify.addHook('preHandler', authenticate);
  fastify.addHook('preHandler', requireRole('ADMIN'));

  // ==========================================
  // Platform Metrics
  // ==========================================

  fastify.get(
    '/analytics/summary',
    {
      schema: {
        description: 'Get comprehensive platform health metrics and KPI counts (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
      },
    },
    adminController.getPlatformSummary.bind(adminController)
  );

  // ==========================================
  // Quotes CMS Studio
  // ==========================================

  fastify.get(
    '/quotes',
    {
      schema: {
        description: 'List quotes catalog with search and pagination (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        querystring: listQuotesAdminQuerySchema,
      },
    },
    adminController.listQuotes.bind(adminController)
  );

  fastify.post(
    '/quotes',
    {
      schema: {
        description: 'Publish a new quote into the motivation catalog (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        body: createAdminQuoteSchema,
      },
    },
    adminController.createQuote.bind(adminController)
  );

  fastify.put(
    '/quotes/:id',
    {
      schema: {
        description: 'Update a quote by ID (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
        body: updateAdminQuoteSchema,
      },
    },
    adminController.updateQuote.bind(adminController)
  );

  fastify.delete(
    '/quotes/:id',
    {
      schema: {
        description: 'Delete a quote by ID (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
      },
    },
    adminController.deleteQuote.bind(adminController)
  );

  // ==========================================
  // Rise Packs Studio
  // ==========================================

  fastify.get(
    '/packs',
    {
      schema: {
        description: 'List all Rise Packs including unpublished drafts (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
      },
    },
    adminController.listPacks.bind(adminController)
  );

  fastify.get(
    '/packs/:id',
    {
      schema: {
        description: 'Get single Rise Pack details and curriculum (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
      },
    },
    adminController.getPackById.bind(adminController)
  );

  fastify.post(
    '/packs',
    {
      schema: {
        description: 'Create a new Rise Pack curriculum (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        body: createAdminPackSchema,
      },
    },
    adminController.createPack.bind(adminController)
  );

  fastify.put(
    '/packs/:id',
    {
      schema: {
        description: 'Update a Rise Pack curriculum and metadata (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
        body: updateAdminPackSchema,
      },
    },
    adminController.updatePack.bind(adminController)
  );

  fastify.delete(
    '/packs/:id',
    {
      schema: {
        description: 'Delete a Rise Pack (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
      },
    },
    adminController.deletePack.bind(adminController)
  );

  // ==========================================
  // Affirmations CMS
  // ==========================================

  fastify.get(
    '/affirmations',
    {
      schema: {
        description: 'List affirmations with category and search filtering (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        querystring: listAffirmationsAdminQuerySchema,
      },
    },
    adminController.listAffirmations.bind(adminController)
  );

  fastify.post(
    '/affirmations',
    {
      schema: {
        description: 'Create a new affirmation (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        body: createAdminAffirmationSchema,
      },
    },
    adminController.createAffirmation.bind(adminController)
  );

  fastify.put(
    '/affirmations/:id',
    {
      schema: {
        description: 'Update an affirmation by ID (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
        body: updateAdminAffirmationSchema,
      },
    },
    adminController.updateAffirmation.bind(adminController)
  );

  fastify.delete(
    '/affirmations/:id',
    {
      schema: {
        description: 'Delete an affirmation by ID (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
      },
    },
    adminController.deleteAffirmation.bind(adminController)
  );

  // ==========================================
  // User Oversight
  // ==========================================

  fastify.get(
    '/users',
    {
      schema: {
        description: 'Search and inspect user profiles, streaks, and tiers (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        querystring: listUsersAdminQuerySchema,
      },
    },
    adminController.listUsers.bind(adminController)
  );

  fastify.patch(
    '/users/:id/subscription',
    {
      schema: {
        description: 'Manually override or grant a user subscription tier (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        params: z.object({ id: z.string().uuid() }),
        body: updateUserSubscriptionAdminSchema,
      },
    },
    adminController.updateUserSubscription.bind(adminController)
  );

  // ==========================================
  // Push Notification Dispatcher
  // ==========================================

  fastify.post(
    '/broadcast',
    {
      schema: {
        description: 'Broadcast an APNs push notification to all active devices (Admin Only)',
        tags: ['Admin'],
        security: [{ bearerAuth: [] }],
        body: broadcastPushSchema,
      },
    },
    adminController.broadcastPush.bind(adminController)
  );
}
