//
//  intentions.routes.ts
//  RiseServer
//
//  Fastify routes for Daily Intentions
//

import { FastifyInstance } from 'fastify';
import { IntentionsService } from './intentions.service.js';
import { IntentionsController } from './intentions.controller.js';
import { createIntentionSchema, toggleIntentionSchema } from './intentions.schema.js';
import { authenticate, optionalAuthenticate } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function intentionsRoutes(fastify: FastifyInstance) {
  const intentionsService = new IntentionsService();
  const intentionsController = new IntentionsController(intentionsService);

  fastify.get(
    '/suggestions',
    {
      preHandler: [optionalAuthenticate],
      schema: {
        description: 'Get curated intention suggestions tailored to focus areas',
        tags: ['Intentions'],
      },
    },
    intentionsController.getSuggestions.bind(intentionsController)
  );

  fastify.get(
    '/today',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Get active intention for specified date (defaults to today)',
        tags: ['Intentions'],
        security: [{ bearerAuth: [] }],
        querystring: z.object({
          date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
        }),
      },
    },
    intentionsController.getIntentionByDate.bind(intentionsController)
  );

  fastify.post(
    '/',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Create or update a daily intention',
        tags: ['Intentions'],
        security: [{ bearerAuth: [] }],
        body: createIntentionSchema,
      },
    },
    intentionsController.createOrUpdate.bind(intentionsController)
  );

  fastify.patch(
    '/:syncId/toggle',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Toggle completion state of a daily intention',
        tags: ['Intentions'],
        security: [{ bearerAuth: [] }],
        params: z.object({
          syncId: z.string().uuid(),
        }),
        body: toggleIntentionSchema,
      },
    },
    intentionsController.toggleCompletion.bind(intentionsController)
  );
}
