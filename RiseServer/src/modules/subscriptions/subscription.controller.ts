//
//  subscription.controller.ts
//  RiseServer
//
//  RevenueCat webhook and subscription status controller
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { SubscriptionService } from './subscription.service.js';
import { RevenueCatWebhookInput } from './subscription.schema.js';
import { successResponse, errorResponse } from '@/utils/response.js';
import { env } from '@/config/env.js';

export class SubscriptionController {
  constructor(private subscriptionService: SubscriptionService) {}

  async handleWebhook(request: FastifyRequest<{ Body: RevenueCatWebhookInput }>, reply: FastifyReply) {
    const authHeader = request.headers['authorization'];
    if (authHeader !== `Bearer ${env.REVENUECAT_WEBHOOK_AUTH_KEY}`) {
      return reply.status(401).send(errorResponse('UNAUTHORIZED', 'Invalid RevenueCat webhook authorization key'));
    }

    const result = await this.subscriptionService.processRevenueCatEvent(request.body);
    return reply.status(200).send(successResponse(result));
  }

  async getStatus(request: FastifyRequest, reply: FastifyReply) {
    const status = await this.subscriptionService.getSubscriptionStatus(request.user.userId);
    return reply.status(200).send(successResponse(status));
  }
}
