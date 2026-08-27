//
//  intentions.service.ts
//  RiseServer
//
//  Business logic for Daily Intentions and focus area suggestions
//

import { prisma } from '@/database/prisma.js';
import { CreateIntentionInput, ToggleIntentionInput } from './intentions.schema.js';

export class IntentionsService {
  private suggestionsCatalog: Record<string, string[]> = {
    Confidence: [
      'Speak my mind clearly and trust my inner wisdom.',
      'Embrace challenges as opportunities to expand my capability.',
      'Walk with composure and acknowledge my achievements.',
      'Let go of the need for outside approval.',
      'Show up fully and unapologetically as myself today.',
    ],
    Focus: [
      'Give my complete presence to one important task at a time.',
      'Eliminate distractions and protect my mental clarity.',
      'Dedicate uninterrupted time to meaningful progress.',
      'Pause before reacting to digital notifications.',
      'Channel my energy toward what truly moves the needle.',
    ],
    Discipline: [
      'Honor the promises I made to myself this morning.',
      'Choose long-term satisfaction over momentary ease.',
      'Maintain my routine even when motivation feels distant.',
      'Take small, consistent steps toward my high-value goals.',
      'Execute with quiet excellence and steady persistence.',
    ],
    Mindfulness: [
      'Anchor myself in the present breath throughout the day.',
      'Notice beauty in everyday moments without rushing.',
      'Listen deeply to others without rehearsing my response.',
      'Respond with intention rather than reacting with impulse.',
      'Treat my mind with kindness and patient understanding.',
    ],
    Gratitude: [
      'Appreciate three simple blessings before the day begins.',
      'Express genuine thanks to someone who supports my path.',
      'Find contentment in what I already have today.',
      'Notice the quiet efforts of those around me.',
      'Frame unexpected shifts with curiosity and appreciation.',
    ],
    Resilience: [
      'Meet obstacles with calm resolve and steady breathing.',
      'Remember that setbacks are temporary lessons in disguise.',
      'Keep moving forward one deliberate step at a time.',
      'Protect my inner peace against external turbulence.',
      'Trust my ability to adapt and overcome any hurdle.',
    ],
    Growth: [
      'Learn something new and remain open to fresh perspectives.',
      'Step slightly beyond my comfortable boundaries today.',
      'Treat mistakes as valuable stepping stones toward mastery.',
      'Seek constructive feedback with an open, eager heart.',
      'Celebrate progress over flawless perfection.',
    ],
  };

  /**
   * Get curated suggested intentions tailored to user's focus areas.
   */
  async getSuggestions(userId?: string) {
    let focusAreas = ['Focus', 'Mindfulness', 'Discipline'];

    if (userId) {
      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: { focusAreas: true },
      });

      if (user && user.focusAreas.length > 0) {
        focusAreas = user.focusAreas;
      }
    }

    const suggestions: Array<{ category: string; text: string }> = [];

    // Prioritize user's focus areas
    for (const area of focusAreas) {
      const items = this.suggestionsCatalog[area] || this.suggestionsCatalog['Focus'];
      items.forEach((text) => suggestions.push({ category: area, text }));
    }

    // Add remaining categories for breadth
    for (const [category, items] of Object.entries(this.suggestionsCatalog)) {
      if (!focusAreas.includes(category)) {
        items.slice(0, 2).forEach((text) => suggestions.push({ category, text }));
      }
    }

    return suggestions;
  }

  /**
   * Get user's daily intention for a specific date (YYYY-MM-DD).
   */
  async getIntentionByDate(userId: string, date: string) {
    const intention = await prisma.dailyIntention.findFirst({
      where: {
        userId,
        date,
        isDeleted: false,
      },
    });

    return intention;
  }

  /**
   * Create or update a daily intention.
   */
  async createOrUpdateIntention(userId: string, input: CreateIntentionInput) {
    const completedAt = input.isCompleted ? new Date() : undefined;

    const intention = await prisma.dailyIntention.upsert({
      where: { userId_syncId: { userId, syncId: input.syncId } },
      update: {
        date: input.date,
        text: input.text,
        category: input.category,
        isCustom: input.isCustom,
        isCompleted: input.isCompleted,
        completedAt,
        clientUpdatedAt: new Date(input.clientUpdatedAt),
        version: { increment: 1 },
      },
      create: {
        userId,
        syncId: input.syncId,
        date: input.date,
        text: input.text,
        category: input.category,
        isCustom: input.isCustom,
        isCompleted: input.isCompleted,
        completedAt,
        clientCreatedAt: new Date(input.clientCreatedAt),
        clientUpdatedAt: new Date(input.clientUpdatedAt),
      },
    });

    return intention;
  }

  /**
   * Toggle completion state of a daily intention.
   */
  async toggleIntentionCompletion(userId: string, syncId: string, input: ToggleIntentionInput) {
    const existing = await prisma.dailyIntention.findUnique({
      where: { userId_syncId: { userId, syncId } },
    });

    if (!existing || existing.isDeleted) {
      throw { statusCode: 404, code: 'INTENTION_NOT_FOUND', message: 'Daily intention not found' };
    }

    const completedAt = input.isCompleted ? new Date() : null;

    const updated = await prisma.dailyIntention.update({
      where: { userId_syncId: { userId, syncId } },
      data: {
        isCompleted: input.isCompleted,
        completedAt,
        clientUpdatedAt: new Date(input.clientUpdatedAt),
        version: { increment: 1 },
      },
    });

    return updated;
  }
}
