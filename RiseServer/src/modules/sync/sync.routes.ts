//
//  sync.routes.ts
//  RiseServer
//
//  Delta sync routes
//

import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { SyncService } from './sync.service.js';
import { SyncController } from './sync.controller.js';
import { deltaSyncSchema, DeltaSyncInput } from './sync.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';
import { requireIdempotency } from '@/middlewares/idempotency.middleware.js';

export async function syncRoutes(fastify: FastifyInstance) {
  const syncService = new SyncService();
  const syncController = new SyncController(syncService);

  fastify.addHook('preHandler', authenticate);

  fastify.post<{ Body: DeltaSyncInput }>(
    '/',
    {
      preHandler: [requireIdempotency],
      schema: {
        description: 'Perform delta synchronization for offline-first journals, saved items, and progress',
        tags: ['Sync'],
        security: [{ bearerAuth: [] }],
        body: deltaSyncSchema,
      },
    },
    async (request: FastifyRequest<{ Body: DeltaSyncInput }>, reply: FastifyReply) => {
      return syncController.deltaSync(request, reply);
    }
  );
}
