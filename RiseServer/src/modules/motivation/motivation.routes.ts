//
//  motivation.routes.ts
//  RiseServer
//
//  Motivation & Affirmations CMS routes
//

import { FastifyInstance } from 'fastify';
import { MotivationService } from './motivation.service.js';
import { MotivationController } from './motivation.controller.js';
import {
  quoteQuerySchema,
  dailyThoughtQuerySchema,
  affirmationQuerySchema,
} from './motivation.schema.js';

export async function motivationRoutes(fastify: FastifyInstance) {
  const motivationService = new MotivationService();
  const motivationController = new MotivationController(motivationService);

  fastify.get(
    '/daily-thought',
    {
      schema: {
        description: 'Get thought of the day for today or a specific day of the year',
        tags: ['Motivation'],
        querystring: dailyThoughtQuerySchema,
      },
    },
    motivationController.getDailyThought.bind(motivationController)
  );

  fastify.get(
    '/catalog',
    {
      schema: {
        description: 'Search and browse quotes with category and keyword matching',
        tags: ['Motivation'],
        querystring: quoteQuerySchema,
      },
    },
    motivationController.getCatalog.bind(motivationController)
  );

  fastify.get(
    '/affirmations/daily',
    {
      schema: {
        description: 'Get daily rotating affirmation for today or a specific day of the year',
        tags: ['Motivation'],
        querystring: dailyThoughtQuerySchema,
      },
    },
    motivationController.getDailyAffirmation.bind(motivationController)
  );

  fastify.get(
    '/affirmations',
    {
      schema: {
        description: 'Search and browse curated affirmations with category and tag filtering',
        tags: ['Motivation'],
        querystring: affirmationQuerySchema,
      },
    },
    motivationController.getAffirmations.bind(motivationController)
  );

  fastify.get(
    '/categories',
    {
      schema: {
        description: 'Get list of unique motivation and affirmation categories',
        tags: ['Motivation'],
      },
    },
    motivationController.getCategories.bind(motivationController)
  );
}
