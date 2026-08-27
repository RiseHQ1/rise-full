//
//  packs.routes.ts
//  RiseServer
//
//  Fastify routes for Rise Packs mini-experiences and user progress
//

import { FastifyInstance } from 'fastify';
import { PacksService } from './packs.service.js';
import { PacksController } from './packs.controller.js';
import { packQuerySchema, updatePackProgressSchema } from './packs.schema.js';
import { authenticate, optionalAuthenticate } from '@/middlewares/auth.middleware.js';
import { z } from 'zod';

export async function packsRoutes(fastify: FastifyInstance) {
  const packsService = new PacksService();
  const packsController = new PacksController(packsService);

  fastify.get(
    '/',
    {
      preHandler: [optionalAuthenticate],
      schema: {
        description: 'List all available Rise Packs with user entitlement and progress state',
        tags: ['Packs'],
        querystring: packQuerySchema,
      },
    },
    packsController.listPacks.bind(packsController)
  );

  fastify.get(
    '/user/progress',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Get user enrolled pack progress list',
        tags: ['Packs'],
        security: [{ bearerAuth: [] }],
      },
    },
    packsController.getUserPackProgress.bind(packsController)
  );

  fastify.get(
    '/:slug',
    {
      preHandler: [optionalAuthenticate],
      schema: {
        description: 'Get single Rise Pack details and curriculum items',
        tags: ['Packs'],
        params: z.object({
          slug: z.string().min(1),
        }),
      },
    },
    packsController.getPackBySlug.bind(packsController)
  );

  fastify.post(
    '/:slug/progress',
    {
      preHandler: [authenticate],
      schema: {
        description: 'Update user progress within a Rise Pack',
        tags: ['Packs'],
        security: [{ bearerAuth: [] }],
        params: z.object({
          slug: z.string().min(1),
        }),
        body: updatePackProgressSchema,
      },
    },
    packsController.updateProgress.bind(packsController)
  );
}
