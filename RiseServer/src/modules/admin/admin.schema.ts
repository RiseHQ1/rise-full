//
//  admin.schema.ts
//  RiseServer
//
//  Zod validation schemas for administrative content management, packs studio, user oversight, and push broadcasts
//

import { z } from 'zod';

// ==========================================
// Quotes CMS Schemas
// ==========================================

export const createAdminQuoteSchema = z.object({
  quote: z.string().min(5),
  author: z.string().min(1),
  category: z.string().min(1),
  tags: z.array(z.string()).default([]),
  assetName: z.string().default('onboarding_motivation_bg'),
  dayOfYear: z.number().int().min(1).max(366).nullable().optional(),
  isFeatured: z.boolean().default(false),
});

export const updateAdminQuoteSchema = createAdminQuoteSchema.partial();

export const listQuotesAdminQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  category: z.string().optional(),
});

// ==========================================
// Packs Studio Schemas
// ==========================================

export const adminPackItemSchema = z.object({
  day: z.number().int().min(1),
  title: z.string().min(1),
  type: z.enum(['BOOST', 'AUDIO', 'REFLECTION', 'BREATHE']).default('BOOST'),
  content: z.string().min(1),
  durationMinutes: z.number().int().min(1).default(3),
  assetName: z.string().default('pack_morning_1'),
  audioUrl: z.string().url().optional(),
});

export const createAdminPackSchema = z.object({
  slug: z.string().min(2).regex(/^[a-z0-9-]+$/),
  title: z.string().min(2),
  subtitle: z.string().min(2),
  description: z.string().min(10),
  heroArtwork: z.string().default('pack_morning_reset'),
  theme: z.string().default('sunrise_gold'),
  category: z.string().min(1),
  durationDays: z.number().int().min(1).default(7),
  accessLevel: z.enum(['FREE', 'PRO', 'STOREKIT_PURCHASE']).default('FREE'),
  storeKitProductId: z.string().nullable().optional(),
  priceTier: z.string().default('Free'),
  items: z.array(adminPackItemSchema).default([]),
  isPublished: z.boolean().default(true),
});

export const updateAdminPackSchema = createAdminPackSchema.partial();

// ==========================================
// Affirmations CMS Schemas
// ==========================================

export const createAdminAffirmationSchema = z.object({
  text: z.string().min(5),
  category: z.string().min(1),
  tags: z.array(z.string()).default([]),
  accessLevel: z.enum(['FREE', 'PRO']).default('FREE'),
  dayOfYear: z.number().int().min(1).max(366).nullable().optional(),
  assetName: z.string().default('onboarding_motivation_bg'),
});

export const updateAdminAffirmationSchema = createAdminAffirmationSchema.partial();

export const listAffirmationsAdminQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  category: z.string().optional(),
  accessLevel: z.enum(['FREE', 'PRO']).optional(),
});

// ==========================================
// User Oversight Schemas
// ==========================================

export const listUsersAdminQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
  tier: z.enum(['FREE', 'PRO_MONTHLY', 'PRO_ANNUAL', 'LIFETIME']).optional(),
  role: z.enum(['USER', 'CURATOR', 'ADMIN']).optional(),
});

export const updateUserSubscriptionAdminSchema = z.object({
  subscriptionTier: z.enum(['FREE', 'PRO_MONTHLY', 'PRO_ANNUAL', 'LIFETIME']),
  expiresAt: z.string().datetime().nullable().optional(),
  role: z.enum(['USER', 'CURATOR', 'ADMIN']).optional(),
});

// ==========================================
// Push Broadcast Schemas
// ==========================================

export const broadcastPushSchema = z.object({
  title: z.string().min(1),
  body: z.string().min(1),
  category: z.string().default('ANNOUNCEMENT'),
  deepLink: z.string().default('rise://home'),
});

export type CreateAdminQuoteInput = z.infer<typeof createAdminQuoteSchema>;
export type UpdateAdminQuoteInput = z.infer<typeof updateAdminQuoteSchema>;
export type ListQuotesAdminQueryInput = z.infer<typeof listQuotesAdminQuerySchema>;

export type CreateAdminPackInput = z.infer<typeof createAdminPackSchema>;
export type UpdateAdminPackInput = z.infer<typeof updateAdminPackSchema>;

export type CreateAdminAffirmationInput = z.infer<typeof createAdminAffirmationSchema>;
export type UpdateAdminAffirmationInput = z.infer<typeof updateAdminAffirmationSchema>;
export type ListAffirmationsAdminQueryInput = z.infer<typeof listAffirmationsAdminQuerySchema>;

export type ListUsersAdminQueryInput = z.infer<typeof listUsersAdminQuerySchema>;
export type UpdateUserSubscriptionAdminInput = z.infer<typeof updateUserSubscriptionAdminSchema>;

export type BroadcastPushInput = z.infer<typeof broadcastPushSchema>;
