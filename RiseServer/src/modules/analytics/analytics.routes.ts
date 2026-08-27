//
//  analytics.routes.ts
//  RiseServer
//
//  Mobile telemetry and event tracking routes
//

import { FastifyInstance } from 'fastify';
import { AnalyticsService } from './analytics.service.js';
import { AnalyticsController } from './analytics.controller.js';
import { batchTelemetrySchema } from './analytics.schema.js';
import { authenticate, requireRole } from '@/middlewares/auth.middleware.js';

export async function analyticsRoutes(fastify: FastifyInstance) {
  const analyticsService = new AnalyticsService();
  const analyticsController = new AnalyticsController(analyticsService);

  fastify.post(
    '/events',
    {
      schema: {
        description: 'Ingest a batch of mobile client usage and telemetry events',
        tags: ['Analytics'],
        body: batchTelemetrySchema,
      },
    },
    analyticsController.ingestBatch.bind(analyticsController)
  );

  fastify.get(
    '/metrics',
    {
      preHandler: [authenticate, requireRole('ADMIN')],
      schema: {
        description: 'Get aggregated metric counts for today (Admin Only)',
        tags: ['Analytics'],
        security: [{ bearerAuth: [] }],
      },
    },
    analyticsController.getDailyMetrics.bind(analyticsController)
  );
}
