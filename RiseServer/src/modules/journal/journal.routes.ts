//
//  journal.routes.ts
//  RiseServer
//
//  Fastify journal and reflection routes
//

import { FastifyInstance } from 'fastify';
import { JournalService } from './journal.service.js';
import { JournalController } from './journal.controller.js';
import { createJournalEntrySchema, journalQuerySchema } from './journal.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function journalRoutes(fastify: FastifyInstance) {
  const journalService = new JournalService();
  const journalController = new JournalController(journalService);

  fastify.addHook('preHandler', authenticate);

  fastify.post(
    '/',
    {
      schema: {
        description: 'Create or update an encrypted journal entry with mood tagging',
        tags: ['Journal'],
        security: [{ bearerAuth: [] }],
        body: createJournalEntrySchema,
      },
    },
    journalController.createEntry.bind(journalController)
  );

  fastify.get(
    '/',
    {
      schema: {
        description: 'List user journal reflections with pagination and mood/tag filters',
        tags: ['Journal'],
        security: [{ bearerAuth: [] }],
        querystring: journalQuerySchema,
      },
    },
    journalController.listEntries.bind(journalController)
  );

  fastify.get(
    '/daily-prompt',
    {
      schema: {
        description: 'Get dynamic rotating time-aware daily reflection prompt (morning, midday, evening)',
        tags: ['Journal'],
        security: [{ bearerAuth: [] }],
      },
    },
    journalController.getDailyPrompt.bind(journalController)
  );

  fastify.get(
    '/:syncId',
    {
      schema: {
        description: 'Get a single journal entry by sync ID',
        tags: ['Journal'],
        security: [{ bearerAuth: [] }],
        params: z.object({
          syncId: z.string().uuid(),
        }),
      },
    },
    journalController.getEntry.bind(journalController)
  );

  fastify.delete(
    '/:syncId',
    {
      schema: {
        description: 'Soft-delete a journal entry by sync ID',
        tags: ['Journal'],
        security: [{ bearerAuth: [] }],
        params: z.object({
          syncId: z.string().uuid(),
        }),
      },
    },
    journalController.deleteEntry.bind(journalController)
  );
}
