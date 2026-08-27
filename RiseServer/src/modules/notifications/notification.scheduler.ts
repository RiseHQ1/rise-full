//
//  notification.scheduler.ts
//  RiseServer
//
//  Timezone-aware routine scheduler (Morning Boost, Evening Reflection, Streak Alert)
//

import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';
import { NotificationDispatcher } from './notification.dispatcher.js';
import { logger } from '@/utils/logger.js';

export class NotificationScheduler {
  private dispatcher = new NotificationDispatcher();

  /**
   * Run hourly cron dispatching routines to users matching target local hour.
   */
  async processHourlyRoutines() {
    const nowUtc = new Date();
    logger.info({ nowUtc: nowUtc.toISOString() }, '⏰ Running hourly timezone notification scan');

    // 1. Find users with active device tokens and notifications enabled
    const activeUsers = await prisma.user.findMany({
      where: {
        notificationsEnabled: true,
        deviceTokens: { some: { isActive: true } },
      },
      include: {
        deviceTokens: { where: { isActive: true } },
        userProgress: true,
      },
    });

    let morningCount = 0;
    let eveningCount = 0;
    let streakAlertCount = 0;

    const today = nowUtc.toISOString().split('T')[0];

    for (const user of activeUsers) {
      const userLocalTime = this.getUserLocalTime(user.timeZone);
      const userTokens = user.deviceTokens.map((t) => t.token);

      // A. Morning Boost check (e.g. "07:00")
      if (userLocalTime === user.morningBoostTime) {
        const dedupKey = `notif_dedup:${user.id}:${today}:MORNING_BOOST`;
        const alreadySent = await redis.get(dedupKey).catch(() => null);

        if (!alreadySent) {
          await redis.set(dedupKey, '1', 'EX', 86400).catch(() => null);
          morningCount++;
          await this.dispatcher.sendPushToDevices(userTokens, {
            title: `Good morning, ${user.name} ☀️`,
            body: 'Your daily thought and morning intention are ready for you.',
            category: 'MORNING_BOOST',
            deepLink: 'rise://morning-boost',
          });
        }
      }

      // B. Evening Reflection check (e.g. "21:00")
      if (userLocalTime === user.eveningReflectionTime) {
        const dedupKey = `notif_dedup:${user.id}:${today}:EVENING_REFLECTION`;
        const alreadySent = await redis.get(dedupKey).catch(() => null);

        if (!alreadySent) {
          await redis.set(dedupKey, '1', 'EX', 86400).catch(() => null);
          eveningCount++;
          await this.dispatcher.sendPushToDevices(userTokens, {
            title: 'Evening Peace & Reflection 🌙',
            body: 'Take 2 minutes to pause, breathe, and reflect on your day.',
            category: 'EVENING_REFLECTION',
            deepLink: 'rise://evening-reflection',
          });
        }
      }

      // C. Streak Protection Reminder at 20:00 (if not active today)
      if (userLocalTime === '20:00' && user.userProgress && user.userProgress.currentStreak > 0) {
        const lastActive = new Date(user.userProgress.lastActiveDate);
        const isToday = lastActive.toDateString() === nowUtc.toDateString();

        if (!isToday) {
          const dedupKey = `notif_dedup:${user.id}:${today}:STREAK_REMINDER`;
          const alreadySent = await redis.get(dedupKey).catch(() => null);

          if (!alreadySent) {
            await redis.set(dedupKey, '1', 'EX', 86400).catch(() => null);
            streakAlertCount++;
            await this.dispatcher.sendPushToDevices(userTokens, {
              title: `Keep your ${user.userProgress.currentStreak}-day streak alive! 🔥`,
              body: 'A quick 1-minute check-in keeps your momentum going strong.',
              category: 'STREAK_REMINDER',
              deepLink: 'rise://breathe',
            });
          }
        }
      }
    }

    logger.info({ morningCount, eveningCount, streakAlertCount }, '✅ Completed hourly notification dispatch');
    return { morningCount, eveningCount, streakAlertCount };
  }

  /**
   * Helper to format current time in user's specific IANA timezone (e.g. "07:00").
   */
  private getUserLocalTime(timeZone: string): string {
    try {
      const formatter = new Intl.DateTimeFormat('en-GB', {
        timeZone,
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      });
      return formatter.format(new Date());
    } catch {
      // Fallback to UTC if timezone invalid
      const formatter = new Intl.DateTimeFormat('en-GB', {
        timeZone: 'UTC',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      });
      return formatter.format(new Date());
    }
  }
}
