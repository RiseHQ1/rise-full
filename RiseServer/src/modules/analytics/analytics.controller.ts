//
//  analytics.controller.ts
//  RiseServer
//
//  Analytics telemetry controller
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { AnalyticsService } from './analytics.service.js';
import { BatchTelemetryInput } from './analytics.schema.js';
import { successResponse } from '@/utils/response.js';

export class AnalyticsController {
  constructor(private analyticsService: AnalyticsService) {}

  async ingestBatch(request: FastifyRequest<{ Body: BatchTelemetryInput }>, reply: FastifyReply) {
    const userId = request.user?.userId;
    const result = await this.analyticsService.ingestEvents(userId, request.body);
    return reply.status(200).send(successResponse(result));
  }

  async getDailyMetrics(_request: FastifyRequest, reply: FastifyReply) {
    const metrics = await this.analyticsService.getDailyMetrics();
    return reply.status(200).send(successResponse(metrics));
  }
}
