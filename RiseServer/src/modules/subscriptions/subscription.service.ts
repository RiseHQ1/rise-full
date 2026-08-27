//
//  subscription.service.ts
//  RiseServer
//
//  RevenueCat webhook event processing and subscription tier management
//

import { prisma } from '@/database/prisma.js';
import { RevenueCatWebhookInput } from './subscription.schema.js';
import { logger } from '@/utils/logger.js';
import { SubscriptionTier, Prisma } from '@prisma/client';

export class SubscriptionService {
  /**
   * Process incoming webhook event from RevenueCat.
   */
  async processRevenueCatEvent(payload: RevenueCatWebhookInput) {
    const event = payload.event;
    const appUserId = event.app_user_id;
    const eventType = event.type;

    logger.info({ eventType, appUserId, productId: event.product_id }, 'Processing RevenueCat webhook event');

    // Determine user by appUserId (or id)
    const user = await prisma.user.findFirst({
      where: {
        OR: [{ id: appUserId }, { revenueCatAppUserId: appUserId }],
      },
    });

    const expiresAt = event.expiration_at_ms ? new Date(event.expiration_at_ms) : null;
    const purchasedAt = event.purchased_at_ms ? new Date(event.purchased_at_ms) : null;

    // Log subscription audit event
    await prisma.subscriptionEvent.create({
      data: {
        userId: user?.id || null,
        eventType,
        originalTransactionId: event.original_app_user_id || event.id,
        productId: event.product_id || null,
        purchasedAt,
        expiresAt,
        rawPayload: payload as unknown as Prisma.InputJsonValue,
      },
    });

    if (!user) {
      logger.warn({ appUserId }, 'User not found for RevenueCat event');
      return { status: 'IGNORED_USER_NOT_FOUND' };
    }

    let updatedTier: SubscriptionTier = user.subscriptionTier;

    switch (eventType) {
      case 'INITIAL_PURCHASE':
      case 'RENEWAL':
      case 'UNCANCELLATION': {
        const productId = (event.product_id || '').toLowerCase();
        if (productId.includes('lifetime')) {
          updatedTier = 'LIFETIME';
        } else if (productId.includes('annual') || productId.includes('year')) {
          updatedTier = 'PRO_ANNUAL';
        } else {
          updatedTier = 'PRO_MONTHLY';
        }
        break;
      }
      case 'EXPIRATION':
      case 'BILLING_ISSUE': {
        updatedTier = 'FREE';
        break;
      }
      case 'CANCELLATION': {
        // Keeps PRO status until expiration date arrives
        break;
      }
      default:
        break;
    }

    await prisma.user.update({
      where: { id: user.id },
      data: {
        subscriptionTier: updatedTier,
        subscriptionExpiresAt: expiresAt,
        revenueCatAppUserId: appUserId,
      },
    });

    logger.info({ userId: user.id, updatedTier, expiresAt }, 'Updated user subscription tier');
    return { status: 'SUCCESS', userId: user.id, tier: updatedTier };
  }

  /**
   * Get subscription status and entitlements for the authenticated user.
   */
  async getSubscriptionStatus(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        subscriptionTier: true,
        subscriptionExpiresAt: true,
        revenueCatAppUserId: true,
      },
    });

    if (!user) {
      throw { statusCode: 404, code: 'USER_NOT_FOUND', message: 'User not found' };
    }

    const isPro =
      user.subscriptionTier === 'LIFETIME' ||
      (user.subscriptionTier !== 'FREE' && (!user.subscriptionExpiresAt || user.subscriptionExpiresAt > new Date()));

    return {
      tier: user.subscriptionTier,
      isPro,
      expiresAt: user.subscriptionExpiresAt?.toISOString() || null,
      appUserId: user.revenueCatAppUserId || user.id,
    };
  }
}
