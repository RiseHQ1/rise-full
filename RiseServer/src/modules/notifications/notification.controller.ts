//
//  notification.controller.ts
//  RiseServer
//
//  Notification device token request handler
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { NotificationService } from './notification.service.js';
import { RegisterDeviceTokenInput } from './notification.schema.js';
import { successResponse } from '@/utils/response.js';

export class NotificationController {
  constructor(private notificationService: NotificationService) {}

  async registerToken(request: FastifyRequest<{ Body: RegisterDeviceTokenInput }>, reply: FastifyReply) {
    const result = await this.notificationService.registerDeviceToken(request.user.userId, request.body);
    return reply.status(200).send(successResponse(result));
  }

  async unregisterToken(request: FastifyRequest<{ Body: { token: string } }>, reply: FastifyReply) {
    const result = await this.notificationService.unregisterDeviceToken(request.body.token, request.user.userId);
    return reply.status(200).send(successResponse(result));
  }
}
