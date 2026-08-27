//
//  index.ts (Worker Runner)
//  RiseServer
//
//  Standalone background worker process for scheduled push routines and data cleanup
//

import { NotificationScheduler } from '@/modules/notifications/notification.scheduler.js';
import { prisma } from '@/database/prisma.js';
import { logger } from '@/utils/logger.js';

async function startWorkers() {
  logger.info('⚙️ Starting Rise Background Worker Process...');
  const scheduler = new NotificationScheduler();

  // Run immediately on boot
  await scheduler.processHourlyRoutines();
  await run30DayPurgeJob();

  // Run timezone routine scan every 10 minutes (to catch exact hour transitions across timezones)
  setInterval(async () => {
    try {
      await scheduler.processHourlyRoutines();
    } catch (err) {
      logger.error({ err }, 'Error in hourly timezone notification scheduler');
    }
  }, 1000 * 60 * 10);

  // Run soft-delete purge once every 24 hours
  setInterval(async () => {
    try {
      await run30DayPurgeJob();
    } catch (err) {
      logger.error({ err }, 'Error in 30-day purge job');
    }
  }, 1000 * 60 * 60 * 24);
}

/**
 * Permanently purge soft-deleted records older than 30 days.
 */
async function run30DayPurgeJob() {
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const [deletedJournals, deletedSaves] = await Promise.all([
    prisma.journalEntry.deleteMany({
      where: {
        isDeleted: true,
        serverUpdatedAt: { lte: thirtyDaysAgo },
      },
    }),
    prisma.savedContent.deleteMany({
      where: {
        isDeleted: true,
        serverUpdatedAt: { lte: thirtyDaysAgo },
      },
    }),
  ]);

  logger.info(
    { purgedJournals: deletedJournals.count, purgedSaves: deletedSaves.count },
    '🧹 Cleaned up soft-deleted records older than 30 days'
  );
}

startWorkers().catch((err) => {
  logger.fatal({ err }, 'Fatal error in worker process');
  process.exit(1);
});

process.on('SIGTERM', async () => {
  logger.info('Worker received SIGTERM, closing database connections...');
  await prisma.$disconnect();
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('Worker received SIGINT, closing database connections...');
  await prisma.$disconnect();
  process.exit(0);
});
