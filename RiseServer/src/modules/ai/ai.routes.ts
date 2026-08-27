//
//  ai.routes.ts
//  RiseServer
//
//  Fastify AI Assistant routes
//

import { FastifyInstance } from 'fastify';
import { AIService } from './ai.service.js';
import { AIController } from './ai.controller.js';
import { aiReflectSchema, aiIntentionGenerateSchema } from './ai.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';

export async function aiRoutes(fastify: FastifyInstance) {
  const aiService = new AIService();
  const aiController = new AIController(aiService);

  fastify.addHook('preHandler', authenticate);

  fastify.post(
    '/reflect',
    {
      schema: {
        description: 'Generate mindful AI reflection insights with crisis safety interception and quota gating',
        tags: ['AI'],
        security: [{ bearerAuth: [] }],
        body: aiReflectSchema,
      },
    },
    aiController.generateReflection.bind(aiController)
  );

  fastify.post(
    '/intention',
    {
      schema: {
        description: 'Generate personalized morning daily intentions based on focus area',
        tags: ['AI'],
        security: [{ bearerAuth: [] }],
        body: aiIntentionGenerateSchema,
      },
    },
    aiController.generateIntention.bind(aiController)
  );

  fastify.get(
    '/weekly-insights',
    {
      schema: {
        description: 'Get weekly emotional analysis and mood trajectory over the past 7 days',
        tags: ['AI'],
        security: [{ bearerAuth: [] }],
      },
    },
    aiController.getWeeklyInsights.bind(aiController)
  );
}
