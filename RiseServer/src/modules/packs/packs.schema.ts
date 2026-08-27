//
//  packs.schema.ts
//  RiseServer
//
//  Zod validation schemas for Rise Packs mini-experiences and user pack progress
//

import { z } from 'zod';

export const packItemSchema = z.object({
  day: z.number().int().min(1),
  title: z.string().min(1),
  subtitle: z.string().optional().nullable(),
  type: z.enum(['BOOST', 'AUDIO', 'INTENTION', 'REFLECTION', 'CHALLENGE']),
  content: z.string().min(1),
  durationMinutes: z.number().int().min(1).default(5),
  assetName: z.string().optional().nullable(),
});

export const createPackSchema = z.object({
  slug: z.string().min(1).regex(/^[a-z0-9-]+$/, 'Slug must be kebab-case lowercase'),
  title: z.string().min(1),
  subtitle: z.string().optional().nullable(),
  description: z.string().min(1),
  heroArtwork: z.string().default('pack_morning_reset'),
  theme: z.string().optional().nullable(),
  category: z.string().default('Growth'),
  durationDays: z.number().int().min(1).default(7),
  accessLevel: z.enum(['FREE', 'PRO', 'STOREKIT_PURCHASE']).default('FREE'),
  storeKitProductId: z.string().optional().nullable(),
  priceTier: z.string().optional().nullable(),
  items: z.array(packItemSchema).min(1),
  isPublished: z.boolean().default(true),
});

export const updatePackProgressSchema = z.object({
  completedItemIds: z.array(z.string()).optional(),
  currentDay: z.number().int().min(1).optional(),
  isCompleted: z.boolean().optional(),
});

export const packQuerySchema = z.object({
  category: z.string().optional(),
  accessLevel: z.enum(['FREE', 'PRO', 'STOREKIT_PURCHASE']).optional(),
});

export type PackItem = z.infer<typeof packItemSchema>;
export type CreatePackInput = z.infer<typeof createPackSchema>;
export type UpdatePackProgressInput = z.infer<typeof updatePackProgressSchema>;
export type PackQueryInput = z.infer<typeof packQuerySchema>;
