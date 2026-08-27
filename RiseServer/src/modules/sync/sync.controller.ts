//
//  sync.controller.ts
//  RiseServer
//
//  Delta sync controller with automatic idempotent response caching
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { SyncService } from './sync.service.js';
import { DeltaSyncInput } from './sync.schema.js';
import { successResponse } from '@/utils/response.js';
import { cacheIdempotentResponse } from '@/middlewares/idempotency.middleware.js';

export class SyncController {
  constructor(private syncService: SyncService) {}

  async deltaSync(request: FastifyRequest<{ Body: DeltaSyncInput }>, reply: FastifyReply) {
    const result = await this.syncService.processDeltaSync(request.user.userId, request.body);
    const responsePayload = successResponse(result);

    // Cache response for idempotent network retry protection
    await cacheIdempotentResponse(request, 200, responsePayload);

    return reply.status(200).send(responsePayload);
  }
}
