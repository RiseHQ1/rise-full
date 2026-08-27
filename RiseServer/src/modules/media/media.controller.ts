//
//  media.controller.ts
//  RiseServer
//
//  Media upload signature request handler
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { MediaService } from './media.service.js';
import { RequestUploadSignatureInput } from './media.schema.js';
import { successResponse } from '@/utils/response.js';

export class MediaController {
  constructor(private mediaService: MediaService) {}

  async getUploadSignature(request: FastifyRequest<{ Body: RequestUploadSignatureInput }>, reply: FastifyReply) {
    const result = await this.mediaService.generateUploadSignature(request.user.userId, request.body);
    return reply.status(200).send(successResponse(result));
  }
}
