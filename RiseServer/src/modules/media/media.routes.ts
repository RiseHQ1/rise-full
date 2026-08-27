//
//  media.routes.ts
//  RiseServer
//
//  Direct image upload signing routes
//

import { FastifyInstance } from 'fastify';
import { MediaService } from './media.service.js';
import { MediaController } from './media.controller.js';
import { requestUploadSignatureSchema } from './media.schema.js';
import { authenticate } from '@/middlewares/auth.middleware.js';

export async function mediaRoutes(fastify: FastifyInstance) {
  const mediaService = new MediaService();
  const mediaController = new MediaController(mediaService);

  fastify.addHook('preHandler', authenticate);

  fastify.post(
    '/upload-signature',
    {
      schema: {
        description: 'Generate secure signed parameters for direct client image uploads (avatars, journal photos, custom card art)',
        tags: ['Media'],
        security: [{ bearerAuth: [] }],
        body: requestUploadSignatureSchema,
      },
    },
    mediaController.getUploadSignature.bind(mediaController)
  );
}
