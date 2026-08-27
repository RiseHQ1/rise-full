//
//  idempotency.middleware.ts
//  RiseServer
//
//  Idempotency middleware preventing duplicate operations on network retries
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { redis } from '@/database/redis.js';
import { logger } from '@/utils/logger.js';

/**
 * Validates Idempotency-Key header on POST/PUT requests to avoid duplicate operations.
 */
export async function requireIdempotency(request: FastifyRequest, reply: FastifyReply) {
  const idempotencyKey = request.headers['idempotency-key'] as string | undefined;
  if (!idempotencyKey) return;

  try {
    const cacheKey = `idempotency:${idempotencyKey}`;
    const cachedResponse = await redis.get(cacheKey);

    if (cachedResponse) {
      logger.info({ idempotencyKey }, 'Returning cached idempotent response');
      const { status, body } = JSON.parse(cachedResponse);
      return reply.status(status).send(body);
    }
  } catch (err) {
    logger.warn({ err }, 'Idempotency cache lookup fallback — proceeding with request');
  }
}

/**
 * Cache an outgoing response payload keyed by the client's Idempotency-Key.
 */
export async function cacheIdempotentResponse(request: FastifyRequest, status: number, body: unknown) {
  const idempotencyKey = request.headers['idempotency-key'] as string | undefined;
  if (!idempotencyKey) return;

  try {
    const cacheKey = `idempotency:${idempotencyKey}`;
    await redis.set(cacheKey, JSON.stringify({ status, body }), 'EX', 86400); // 24 hours TTL
  } catch (err) {
    logger.warn({ err }, 'Failed to cache idempotent response');
  }
}
