//
//  discover.routes.ts
//  RiseServer
//
//  Fastify routes for Discovery Hub and Universal Search
//

import { FastifyInstance } from 'fastify';
import { DiscoverService } from './discover.service.js';
import { DiscoverController } from './discover.controller.js';
import { universalSearchQuerySchema } from './discover.schema.js';
import { optionalAuthenticate } from '@/middlewares/auth.middleware.js';

export async function discoverRoutes(fastify: FastifyInstance) {
  const discoverService = new DiscoverService();
  const discoverController = new DiscoverController(discoverService);

  fastify.get(
    '/',
    {
      preHandler: [optionalAuthenticate],
      schema: {
        description: 'Get consolidated Discovery Hub feed (Daily Boost, Affirmation, Packs, Themes, Breathing Resets)',
        tags: ['Discover'],
      },
    },
    discoverController.getDiscoveryHub.bind(discoverController)
  );

  fastify.get(
    '/search',
    {
      schema: {
        description: 'Universal multi-entity search across quotes, affirmations, and Rise Packs',
        tags: ['Discover'],
        querystring: universalSearchQuerySchema,
      },
    },
    discoverController.search.bind(discoverController)
  );
}
