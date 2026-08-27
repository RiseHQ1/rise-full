//
//  motivation.schema.ts
//  RiseServer
//
//  Zod validation schemas for motivation content catalog & affirmations
//

import { z } from 'zod';

export const quoteQuerySchema = z.object({
  category: z.string().optional(),
  search: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  page: z.coerce.number().int().min(1).default(1),
});

export const affirmationQuerySchema = z.object({
  category: z.string().optional(),
  tag: z.string().optional(),
  search: z.string().optional(),
  accessLevel: z.enum(['FREE', 'PRO']).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  page: z.coerce.number().int().min(1).default(1),
});

export const dailyThoughtQuerySchema = z.object({
  dayOfYear: z.coerce.number().int().min(1).max(366).optional(),
});

export type QuoteQueryInput = z.infer<typeof quoteQuerySchema>;
export type AffirmationQueryInput = z.infer<typeof affirmationQuerySchema>;
export type DailyThoughtQueryInput = z.infer<typeof dailyThoughtQuerySchema>;
