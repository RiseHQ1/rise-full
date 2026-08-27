//
//  app.ts
//  RiseServer
//
//  Fastify application factory with security, validation, OpenAPI docs, and routes
//

import fastify, { FastifyInstance } from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import rateLimit from '@fastify/rate-limit';
import jwt from '@fastify/jwt';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import { serializerCompiler, validatorCompiler } from 'fastify-type-provider-zod';

import { env } from '@/config/env.js';
import { errorHandler } from '@/middlewares/errorHandler.js';
import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';
import { successResponse } from '@/utils/response.js';

// Route imports
import { authRoutes } from '@/modules/auth/auth.routes.js';
import { userRoutes } from '@/modules/user/user.routes.js';
import { journalRoutes } from '@/modules/journal/journal.routes.js';
import { syncRoutes } from '@/modules/sync/sync.routes.js';
import { motivationRoutes } from '@/modules/motivation/motivation.routes.js';
import { subscriptionRoutes } from '@/modules/subscriptions/subscription.routes.js';
import { notificationRoutes } from '@/modules/notifications/notification.routes.js';
import { aiRoutes } from '@/modules/ai/ai.routes.js';
import { analyticsRoutes } from '@/modules/analytics/analytics.routes.js';
import { adminRoutes } from '@/modules/admin/admin.routes.js';
import { mediaRoutes } from '@/modules/media/media.routes.js';
import { progressRoutes } from '@/modules/progress/progress.routes.js';
import { packsRoutes } from '@/modules/packs/packs.routes.js';
import { intentionsRoutes } from '@/modules/intentions/intentions.routes.js';
import { discoverRoutes } from '@/modules/discover/discover.routes.js';

export async function buildApp(): Promise<FastifyInstance> {
  const app = fastify({
    logger: false, // Managed via custom Pino logger
    trustProxy: true,
  });

  // Zod Type Provider compilers
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);

  // Security headers & CORS
  await app.register(helmet, {
    contentSecurityPolicy: env.NODE_ENV === 'production',
  });

  await app.register(cors, {
    origin: true,
    credentials: true,
  });

  // Rate Limiting
  await app.register(rateLimit, {
    max: env.RATE_LIMIT_MAX,
    timeWindow: env.RATE_LIMIT_TIME_WINDOW,
  });

  // JWT Authentication
  await app.register(jwt, {
    secret: env.JWT_ACCESS_SECRET,
    sign: {
      expiresIn: env.JWT_ACCESS_EXPIRES_IN,
    },
  });

  // Swagger / OpenAPI documentation
  await app.register(swagger, {
    openapi: {
      info: {
        title: 'Rise Mobile API',
        description: 'Production-ready REST and Delta Sync API for Rise iOS application',
        version: '1.0.0',
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT',
          },
        },
      },
    },
  });

  await app.register(swaggerUi, {
    routePrefix: '/docs',
    uiConfig: {
      docExpansion: 'list',
      deepLinking: true,
    },
  });

  // Centralized RFC 7807 Error Handler
  app.setErrorHandler(errorHandler);

  // Liveness & Readiness Health Probe
  app.get('/health', async (_req, reply) => {
    let dbStatus = 'healthy';
    let redisStatus = 'healthy';

    try {
      await prisma.$queryRaw`SELECT 1`;
    } catch {
      dbStatus = 'unreachable';
    }

    try {
      await redis.ping();
    } catch {
      redisStatus = 'unreachable';
    }

    const isHealthy = dbStatus === 'healthy' && redisStatus === 'healthy';

    return reply.status(isHealthy ? 200 : 503).send(
      successResponse({
        status: isHealthy ? 'ok' : 'degraded',
        services: {
          database: dbStatus,
          cache: redisStatus,
        },
        uptimeSeconds: Math.floor(process.uptime()),
        memoryUsage: process.memoryUsage(),
      })
    );
  });

  // App Store Mandated Legal Endpoints
  app.get('/privacy', async (_req, reply) => {
    return reply.status(200).send(
      successResponse({
        title: 'Rise Privacy Policy',
        effectiveDate: '2026-08-24',
        summary: 'Your reflections and mental wellness data are private and belong solely to you.',
      })
    );
  });

  app.get('/terms', async (_req, reply) => {
    return reply.status(200).send(
      successResponse({
        title: 'Rise Terms of Service',
        effectiveDate: '2026-08-24',
        summary: 'Rise provides daily inspiration, breathwork tools, and mindful reflection resources.',
      })
    );
  });

  // API Modules
  await app.register(authRoutes, { prefix: `${env.API_PREFIX}/auth` });
  await app.register(userRoutes, { prefix: `${env.API_PREFIX}/user` });
  await app.register(journalRoutes, { prefix: `${env.API_PREFIX}/journal` });
  await app.register(syncRoutes, { prefix: `${env.API_PREFIX}/sync` });
  await app.register(motivationRoutes, { prefix: `${env.API_PREFIX}/motivation` });
  await app.register(subscriptionRoutes, { prefix: `${env.API_PREFIX}/subscriptions` });
  await app.register(notificationRoutes, { prefix: `${env.API_PREFIX}/notifications` });
  await app.register(aiRoutes, { prefix: `${env.API_PREFIX}/ai` });
  await app.register(analyticsRoutes, { prefix: `${env.API_PREFIX}/analytics` });
  await app.register(adminRoutes, { prefix: `${env.API_PREFIX}/admin` });
  await app.register(mediaRoutes, { prefix: `${env.API_PREFIX}/media` });
  await app.register(progressRoutes, { prefix: `${env.API_PREFIX}/progress` });
  await app.register(packsRoutes, { prefix: `${env.API_PREFIX}/packs` });
  await app.register(intentionsRoutes, { prefix: `${env.API_PREFIX}/intentions` });
  await app.register(discoverRoutes, { prefix: `${env.API_PREFIX}/discover` });

  return app;
}
