//
//  media.service.ts
//  RiseServer
//
//  Cloudinary & S3/R2 direct client upload signing engine
//

import crypto from 'node:crypto';
import { RequestUploadSignatureInput } from './media.schema.js';
import { logger } from '@/utils/logger.js';

export class MediaService {
  /**
   * Generate signed parameters for direct, secure client-to-CDN upload (Cloudinary / R2 / S3).
   */
  async generateUploadSignature(userId: string, input: RequestUploadSignatureInput) {
    const timestamp = Math.floor(Date.now() / 1000);
    const targetFolder = `rise_app/${input.folder}/${userId}`;
    const cloudName = process.env.CLOUDINARY_CLOUD_NAME || 'rise-cloud';
    const apiKey = process.env.CLOUDINARY_API_KEY || 'rise_api_key_demo';
    const apiSecret = process.env.CLOUDINARY_API_SECRET || 'rise_api_secret_demo';

    const transformation =
      input.folder === 'avatars'
        ? 'w_400,h_400,c_fill,g_face,q_auto,f_auto'
        : 'w_1200,q_auto,f_auto';

    // Cloudinary signature calculation: SHA-1 of alphabetically sorted parameter string + apiSecret
    const stringToSign = `folder=${targetFolder}&timestamp=${timestamp}&transformation=${transformation}${apiSecret}`;
    const signature = crypto.createHash('sha1').update(stringToSign).digest('hex');

    logger.info({ userId, folder: input.folder }, '🖼️ Generated signed upload signature for client upload');

    return {
      provider: 'cloudinary',
      uploadUrl: `https://api.cloudinary.com/v1_1/${cloudName}/image/upload`,
      params: {
        api_key: apiKey,
        timestamp,
        folder: targetFolder,
        transformation,
        signature,
      },
    };
  }
}
