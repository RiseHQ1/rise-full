//
//  discover.schema.ts
//  RiseServer
//
//  Zod validation schemas for Discovery Hub and Unified Universal Search
//

import { z } from 'zod';

export const universalSearchQuerySchema = z.object({
  q: z.string().min(1).max(100),
  category: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

export type UniversalSearchQueryInput = z.infer<typeof universalSearchQuerySchema>;
