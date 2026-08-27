//
//  progress.routes.ts
//  RiseServer
//
//  Progress milestones routes
//

import { FastifyInstance } from 'fastify';
import { ProgressService } from './progress.service.js';
import { ProgressController } from './progress.controller.js';
import { authenticate } from '@/middlewares/auth.middleware.js';

export async function progressRoutes(fastify: FastifyInstance) {
  const progressService = new ProgressService();
  const progressController = new ProgressController(progressService);

  fastify.addHook('preHandler', authenticate);

  fastify.get(
    '/milestones',
    {
      schema: {
        description: 'Get unlocked milestone badges and achievement progress for the user',
        tags: ['Progress'],
        security: [{ bearerAuth: [] }],
      },
    },
    progressController.getMilestones.bind(progressController)
  );
}
