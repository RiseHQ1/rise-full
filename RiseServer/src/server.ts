//
//  server.ts
//  RiseServer
//
//  Production server bootstrapper with graceful shutdown handling
//

import { buildApp } from './app.js';
import { env } from '@/config/env.js';
import { logger } from '@/utils/logger.js';
import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';

async function startServer() {
  const app = await buildApp();

  try {
    await app.listen({
      port: env.PORT,
      host: env.HOST,
    });

    logger.info(`🚀 Rise Backend Server listening at http://${env.HOST}:${env.PORT}`);
    logger.info(`📖 Interactive API Documentation available at http://${env.HOST}:${env.PORT}/docs`);
    logger.info(`🩺 Health check probe available at http://${env.HOST}:${env.PORT}/health`);
  } catch (err) {
    logger.fatal({ err }, 'Failed to start server');
    process.exit(1);
  }

  // Graceful shutdown handling
  const signals: NodeJS.Signals[] = ['SIGINT', 'SIGTERM'];
  signals.forEach((signal) => {
    process.on(signal, async () => {
      logger.info(`Received ${signal}, initiating graceful shutdown...`);

      try {
        await app.close();
        await prisma.$disconnect();
        redis.disconnect();
        logger.info('Graceful shutdown completed successfully');
        process.exit(0);
      } catch (err) {
        logger.error({ err }, 'Error during graceful shutdown');
        process.exit(1);
      }
    });
  });
}

startServer();
