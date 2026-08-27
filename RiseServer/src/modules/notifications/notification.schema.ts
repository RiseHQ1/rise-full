//
//  notification.schema.ts
//  RiseServer
//
//  Zod validation schemas for APNs push notification device token registration
//

import { z } from 'zod';

export const registerDeviceTokenSchema = z.object({
  token: z.string().min(1, 'Device token is required'),
  platform: z.enum(['iOS', 'iPadOS', 'macOS', 'watchOS', 'visionOS']).default('iOS'),
});

export type RegisterDeviceTokenInput = z.infer<typeof registerDeviceTokenSchema>;
