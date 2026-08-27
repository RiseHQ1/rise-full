//
//  sync.service.ts
//  RiseServer
//
//  Delta Sync engine with Last-Write-Wins conflict resolution & ACID Transaction Isolation
//

import { prisma } from '@/database/prisma.js';
import { DeltaSyncInput } from './sync.schema.js';
import { Prisma } from '@prisma/client';

export class SyncService {
  /**
   * Process client mutations and fetch server changes since last sync timestamp.
   */
  async processDeltaSync(userId: string, input: DeltaSyncInput) {
    const serverTimestamp = new Date();
    const lastSynced = input.lastSyncedAt ? new Date(input.lastSyncedAt) : new Date(0);

    // Max allowed future timestamp (prevent clock skew anomalies > 60s)
    const maxAllowedFuture = new Date(Date.now() + 60 * 1000);

    // 1. Transactionally apply all mutations atomically
    await prisma.$transaction(async (tx) => {
      // A. Process journal entries
      for (const item of input.journals) {
        const rawClientUpdate = new Date(item.clientUpdatedAt);
        const clientUpdate = rawClientUpdate > maxAllowedFuture ? serverTimestamp : rawClientUpdate;

        const existing = await tx.journalEntry.findUnique({
          where: { userId_syncId: { userId, syncId: item.syncId } },
        });

        if (!existing || clientUpdate >= existing.clientUpdatedAt) {
          await tx.journalEntry.upsert({
            where: { userId_syncId: { userId, syncId: item.syncId } },
            update: {
              mood: item.mood,
              prompt: item.prompt,
              encryptedContent: item.encryptedContent,
              iv: item.iv,
              authTag: item.authTag,
              plainTextFallback: item.plainTextFallback,
              tags: item.tags,
              clientUpdatedAt: clientUpdate,
              isDeleted: item.isDeleted,
              version: { increment: 1 },
            },
            create: {
              syncId: item.syncId,
              userId,
              mood: item.mood,
              prompt: item.prompt,
              encryptedContent: item.encryptedContent,
              iv: item.iv,
              authTag: item.authTag,
              plainTextFallback: item.plainTextFallback,
              tags: item.tags,
              clientCreatedAt: new Date(item.clientCreatedAt),
              clientUpdatedAt: clientUpdate,
              isDeleted: item.isDeleted,
              version: item.version,
            },
          });
        }
      }

      // B. Process saved content favorites
      for (const item of input.savedItems) {
        const rawClientUpdate = new Date(item.clientUpdatedAt);
        const clientUpdate = rawClientUpdate > maxAllowedFuture ? serverTimestamp : rawClientUpdate;

        const existing = await tx.savedContent.findUnique({
          where: { userId_syncId: { userId, syncId: item.syncId } },
        });

        if (!existing || clientUpdate >= existing.clientUpdatedAt) {
          await tx.savedContent.upsert({
            where: { userId_syncId: { userId, syncId: item.syncId } },
            update: {
              title: item.title,
              subtitle: item.subtitle,
              category: item.category,
              assetName: item.assetName,
              isFavorite: item.isFavorite,
              clientUpdatedAt: clientUpdate,
              isDeleted: item.isDeleted,
              version: { increment: 1 },
            },
            create: {
              syncId: item.syncId,
              userId,
              title: item.title,
              subtitle: item.subtitle,
              category: item.category,
              assetName: item.assetName,
              isFavorite: item.isFavorite,
              clientUpdatedAt: clientUpdate,
              isDeleted: item.isDeleted,
              version: item.version,
            },
          });
        }
      }

      // C. Process daily intentions
      if (input.intentions && input.intentions.length > 0) {
        for (const item of input.intentions) {
          const rawClientUpdate = new Date(item.clientUpdatedAt);
          const clientUpdate = rawClientUpdate > maxAllowedFuture ? serverTimestamp : rawClientUpdate;
          const completedAt = item.isCompleted
            ? (item.completedAt ? new Date(item.completedAt) : serverTimestamp)
            : null;

          const existing = await tx.dailyIntention.findUnique({
            where: { userId_syncId: { userId, syncId: item.syncId } },
          });

          if (!existing || clientUpdate >= existing.clientUpdatedAt) {
            await tx.dailyIntention.upsert({
              where: { userId_syncId: { userId, syncId: item.syncId } },
              update: {
                date: item.date,
                text: item.text,
                category: item.category,
                isCustom: item.isCustom,
                isCompleted: item.isCompleted,
                completedAt,
                clientUpdatedAt: clientUpdate,
                isDeleted: item.isDeleted,
                version: { increment: 1 },
              },
              create: {
                syncId: item.syncId,
                userId,
                date: item.date,
                text: item.text,
                category: item.category,
                isCustom: item.isCustom,
                isCompleted: item.isCompleted,
                completedAt,
                clientCreatedAt: new Date(item.clientCreatedAt),
                clientUpdatedAt: clientUpdate,
                isDeleted: item.isDeleted,
                version: item.version,
              },
            });
          }
        }
      }

      // D. Update user progress stats
      if (input.progress) {
        await tx.userProgress.upsert({
          where: { userId },
          update: {
            ...(input.progress.currentStreak !== undefined && { currentStreak: input.progress.currentStreak }),
            ...(input.progress.bestStreak !== undefined && { bestStreak: input.progress.bestStreak }),
            ...(input.progress.mindfulMinutes !== undefined && { mindfulMinutes: input.progress.mindfulMinutes }),
            ...(input.progress.reflectionCount !== undefined && { reflectionCount: input.progress.reflectionCount }),
            ...(input.progress.focusCount !== undefined && { focusCount: input.progress.focusCount }),
            ...(input.progress.weeklyActivity && { weeklyActivity: input.progress.weeklyActivity as Prisma.InputJsonValue }),
            lastActiveDate: serverTimestamp,
          },
          create: {
            userId,
            currentStreak: input.progress.currentStreak || 0,
            bestStreak: input.progress.bestStreak || 0,
            mindfulMinutes: input.progress.mindfulMinutes || 0,
            reflectionCount: input.progress.reflectionCount || 0,
            focusCount: input.progress.focusCount || 0,
            weeklyActivity: (input.progress.weeklyActivity as Prisma.InputJsonValue) || {},
            lastActiveDate: serverTimestamp,
          },
        });
      }
    });

    // 2. Fetch server-side changes modified since lastSynced
    const [serverJournals, serverSavedItems, serverIntentions, userProgress] = await Promise.all([
      prisma.journalEntry.findMany({
        where: {
          userId,
          serverUpdatedAt: { gt: lastSynced },
        },
      }),
      prisma.savedContent.findMany({
        where: {
          userId,
          serverUpdatedAt: { gt: lastSynced },
        },
      }),
      prisma.dailyIntention.findMany({
        where: {
          userId,
          serverUpdatedAt: { gt: lastSynced },
        },
      }),
      prisma.userProgress.findUnique({
        where: { userId },
      }),
    ]);

    return {
      syncedAt: serverTimestamp.toISOString(),
      journals: serverJournals,
      savedItems: serverSavedItems,
      intentions: serverIntentions,
      progress: userProgress,
    };
  }
}
