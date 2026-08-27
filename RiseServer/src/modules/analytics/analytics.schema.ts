//
//  analytics.schema.ts
//  RiseServer
//
//  Zod validation schemas for client telemetry and mobile event batch ingestion
//

import { z } from 'zod';

export const telemetryEventSchema = z.object({
  eventName: z.string().min(1).max(100),
  timestamp: z.string().datetime(),
  sessionId: z.string().optional(),
  properties: z.record(z.any()).default({}),
});

export const batchTelemetrySchema = z.object({
  events: z.array(telemetryEventSchema).min(1).max(100),
});

export type TelemetryEvent = z.infer<typeof telemetryEventSchema>;
export type BatchTelemetryInput = z.infer<typeof batchTelemetrySchema>;
