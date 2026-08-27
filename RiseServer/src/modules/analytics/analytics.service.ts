//
//  analytics.service.ts
//  RiseServer
//
//  Analytics ingestion and real-time metric counters via Redis
//

import { BatchTelemetryInput } from './analytics.schema.js';
import { redis } from '@/database/redis.js';
import { logger } from '@/utils/logger.js';

export class AnalyticsService {
  /**
   * Ingest a batch of mobile client telemetry events.
   */
  async ingestEvents(userId: string | undefined, input: BatchTelemetryInput) {
    const today = new Date().toISOString().split('T')[0];

    for (const event of input.events) {
      logger.info(
        {
          userId: userId || 'anonymous',
          eventName: event.eventName,
          sessionId: event.sessionId,
          properties: event.properties,
          timestamp: event.timestamp,
        },
        '📊 Mobile Telemetry Event'
      );

      // Increment daily event counter in Redis (fault-tolerant)
      try {
        const metricKey = `analytics:daily:${today}:${event.eventName}`;
        await redis.incr(metricKey);
        await redis.expire(metricKey, 86400 * 30); // 30 days retention
      } catch (err) {
        logger.warn({ err }, 'Redis analytics counter fallback');
      }
    }

    return {
      processedCount: input.events.length,
      status: 'INGESTED',
    };
  }

  /**
   * Retrieve aggregated event counts for today.
   */
  async getDailyMetrics() {
    const today = new Date().toISOString().split('T')[0];
    const pattern = `analytics:daily:${today}:*`;
    const metrics: Record<string, number> = {};

    try {
      const keys = await redis.keys(pattern);
      for (const key of keys) {
        const eventName = key.replace(`analytics:daily:${today}:`, '');
        const count = await redis.get(key);
        metrics[eventName] = count ? parseInt(count, 10) : 0;
      }
    } catch (err) {
      logger.warn({ err }, 'Redis getDailyMetrics fallback');
    }

    return {
      date: today,
      metrics,
    };
  }
}
