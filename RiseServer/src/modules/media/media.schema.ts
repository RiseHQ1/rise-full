//
//  media.schema.ts
//  RiseServer
//
//  Zod validation schemas for Cloudinary and S3/R2 image upload signatures
//

import { z } from 'zod';

export const mediaFolderEnum = z.enum([
  'avatars',
  'journal_attachments',
  'quote_backgrounds',
  'curated_artworks',
]);

export const requestUploadSignatureSchema = z.object({
  folder: mediaFolderEnum.default('avatars'),
  fileType: z.string().default('image/jpeg'),
  customId: z.string().optional(),
});

export type MediaFolder = z.infer<typeof mediaFolderEnum>;
export type RequestUploadSignatureInput = z.infer<typeof requestUploadSignatureSchema>;
