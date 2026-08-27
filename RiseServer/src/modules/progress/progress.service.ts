//
//  progress.service.ts
//  RiseServer
//
//  Milestone badges unlock engine and mindful streak analytics
//

import { prisma } from '@/database/prisma.js';

export interface MilestoneBadge {
  id: string;
  title: string;
  description: string;
  icon: string;
  category: 'STREAK' | 'MINDFULNESS' | 'JOURNAL' | 'WISDOM';
  isUnlocked: boolean;
  unlockedAt?: string;
  progressPercentage: number;
}

export class ProgressService {
  /**
   * Evaluate and return all milestone badges and unlock status for a user.
   */
  async getMilestones(userId: string) {
    const progress = await prisma.userProgress.findUnique({
      where: { userId },
    });

    const currentStreak = progress?.currentStreak || 0;
    const mindfulMins = progress?.mindfulMinutes || 0;
    const reflectionCount = progress?.reflectionCount || 0;
    const focusCount = progress?.focusCount || 0;

    const badges: MilestoneBadge[] = [
      {
        id: 'first_step',
        title: 'First Step',
        description: 'Complete your first reflection or mindful breathing session',
        icon: 'sprout.fill',
        category: 'JOURNAL',
        isUnlocked: reflectionCount >= 1 || mindfulMins >= 1,
        progressPercentage: Math.min(100, Math.round((Math.max(reflectionCount, mindfulMins) / 1) * 100)),
      },
      {
        id: 'streak_3_days',
        title: 'Momentum Builder',
        description: 'Maintain a 3-day consistency streak',
        icon: 'flame.fill',
        category: 'STREAK',
        isUnlocked: currentStreak >= 3,
        progressPercentage: Math.min(100, Math.round((currentStreak / 3) * 100)),
      },
      {
        id: 'streak_7_days',
        title: '7-Day Master',
        description: 'Achieve a full week of daily mindfulness',
        icon: 'crown.fill',
        category: 'STREAK',
        isUnlocked: currentStreak >= 7,
        progressPercentage: Math.min(100, Math.round((currentStreak / 7) * 100)),
      },
      {
        id: 'mindful_100_mins',
        title: 'Zen Centered',
        description: 'Accumulate 100 mindful minutes',
        icon: 'wind',
        category: 'MINDFULNESS',
        isUnlocked: mindfulMins >= 100,
        progressPercentage: Math.min(100, Math.round((mindfulMins / 100) * 100)),
      },
      {
        id: 'journal_25_reflections',
        title: 'Deep Inquirer',
        description: 'Record 25 mindful journal reflections',
        icon: 'book.closed.fill',
        category: 'JOURNAL',
        isUnlocked: reflectionCount >= 25,
        progressPercentage: Math.min(100, Math.round((reflectionCount / 25) * 100)),
      },
      {
        id: 'focus_10_sessions',
        title: 'Unshakeable Focus',
        description: 'Complete 10 focused breathing or motivation sessions',
        icon: 'bolt.fill',
        category: 'WISDOM',
        isUnlocked: focusCount >= 10,
        progressPercentage: Math.min(100, Math.round((focusCount / 10) * 100)),
      },
    ];

    const unlockedCount = badges.filter((b) => b.isUnlocked).length;

    return {
      unlockedCount,
      totalCount: badges.length,
      badges,
    };
  }
}
