//
//  progress.controller.ts
//  RiseServer
//
//  Progress milestones and achievements controller
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { ProgressService } from './progress.service.js';
import { successResponse } from '@/utils/response.js';

export class ProgressController {
  constructor(private progressService: ProgressService) {}

  async getMilestones(request: FastifyRequest, reply: FastifyReply) {
    const milestones = await this.progressService.getMilestones(request.user.userId);
    return reply.status(200).send(successResponse(milestones));
  }
}
