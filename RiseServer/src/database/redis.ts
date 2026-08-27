//
//  redis.ts
//  RiseServer
//
//  Redis client singleton for caching, rate limiting, and BullMQ queues
//

import { Redis } from 'ioredis';
import { env } from '@/config/env.js';
import { logger } from '@/utils/logger.js';

export const redis = new Redis(env.REDIS_URL, {
  maxRetriesPerRequest: null,
  enableReadyCheck: true,
  retryStrategy(times) {
    const delay = Math.min(times * 100, 3000);
    logger.warn({ attempt: times, delayMs: delay }, 'Reconnecting to Redis...');
    return delay;
  },
});

redis.on('connect', () => {
  logger.info('Connected to Redis server');
});

redis.on('error', (err) => {
  logger.error({ err }, 'Redis connection error');
});
