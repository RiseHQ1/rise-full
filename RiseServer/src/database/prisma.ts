//
//  prisma.ts
//  RiseServer
//
//  Prisma client singleton with lifecycle management
//

import { PrismaClient } from '@prisma/client';
import { env } from '@/config/env.js';
import { logger } from '@/utils/logger.js';

const prismaClientSingleton = () => {
  return new PrismaClient({
    log:
      env.NODE_ENV === 'development'
        ? [
            { emit: 'event', level: 'query' },
            { emit: 'event', level: 'error' },
            { emit: 'event', level: 'warn' },
          ]
        : [{ emit: 'event', level: 'error' }],
  });
};

declare global {
  var globalPrisma: undefined | ReturnType<typeof prismaClientSingleton>;
}

export const prisma = globalThis.globalPrisma ?? prismaClientSingleton();

if (env.NODE_ENV !== 'production') {
  globalThis.globalPrisma = prisma;
}

// Log Prisma database queries in development
if (env.NODE_ENV === 'development') {
  // @ts-ignore
  prisma.$on('query', (e: { query: string; duration: number }) => {
    logger.debug({ query: e.query, durationMs: e.duration }, 'Database Query');
  });
}

// @ts-ignore
prisma.$on('error', (e: { message: string }) => {
  logger.error({ error: e.message }, 'Database Error');
});
