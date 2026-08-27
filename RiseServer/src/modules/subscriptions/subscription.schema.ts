//
//  subscription.schema.ts
//  RiseServer
//
//  Zod validation schemas for RevenueCat webhook events and subscription status
//

import { z } from 'zod';

export const revenueCatEventSchema = z.object({
  api_version: z.string().optional(),
  event: z.object({
    type: z.string(),
    id: z.string(),
    app_user_id: z.string(),
    original_app_user_id: z.string().optional(),
    product_id: z.string().optional(),
    entitlement_id: z.string().optional().nullable(),
    entitlement_ids: z.array(z.string()).optional(),
    period_type: z.string().optional(),
    purchased_at_ms: z.number().optional(),
    expiration_at_ms: z.number().optional().nullable(),
    environment: z.string().optional(),
  }),
});

export type RevenueCatWebhookInput = z.infer<typeof revenueCatEventSchema>;
