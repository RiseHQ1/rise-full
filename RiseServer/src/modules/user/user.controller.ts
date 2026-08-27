//
//  user.controller.ts
//  RiseServer
//
//  User controller handling profile, preferences, and account deletion
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { UserService } from './user.service.js';
import { UpdateProfileInput, ChangePasswordInput } from './user.schema.js';
import { successResponse } from '@/utils/response.js';

export class UserController {
  constructor(private userService: UserService) {}

  async getMe(request: FastifyRequest, reply: FastifyReply) {
    const profile = await this.userService.getProfile(request.user.userId);
    return reply.status(200).send(successResponse(profile));
  }

  async updateMe(request: FastifyRequest<{ Body: UpdateProfileInput }>, reply: FastifyReply) {
    const profile = await this.userService.updateProfile(request.user.userId, request.body);
    return reply.status(200).send(successResponse(profile));
  }

  async changePassword(request: FastifyRequest<{ Body: ChangePasswordInput }>, reply: FastifyReply) {
    const result = await this.userService.changePassword(request.user.userId, request.body);
    return reply.status(200).send(successResponse(result));
  }

  async exportData(request: FastifyRequest, reply: FastifyReply) {
    const data = await this.userService.exportUserData(request.user.userId);
    return reply.status(200).send(successResponse(data));
  }

  async deleteAccount(request: FastifyRequest, reply: FastifyReply) {
    const result = await this.userService.deleteAccount(request.user.userId);
    return reply.status(200).send(successResponse(result));
  }
}
