//
//  notification.service.ts
//  RiseServer
//
//  Device token management and timezone-aware push notification scheduling
//

import { prisma } from '@/database/prisma.js';
import { RegisterDeviceTokenInput } from './notification.schema.js';
import { logger } from '@/utils/logger.js';

export class NotificationService {
  /**
   * Register or update an APNs device push token for a user.
   */
  async registerDeviceToken(userId: string, input: RegisterDeviceTokenInput) {
    const tokenRecord = await prisma.deviceToken.upsert({
      where: { token: input.token },
      update: {
        userId,
        platform: input.platform,
        isActive: true,
      },
      create: {
        userId,
        token: input.token,
        platform: input.platform,
        isActive: true,
      },
    });

    logger.info({ userId, platform: input.platform }, 'Registered APNs device token');
    return tokenRecord;
  }

  /**
   * Deactivate a device token on user logout.
   */
  async unregisterDeviceToken(token: string, userId: string) {
    await prisma.deviceToken.updateMany({
      where: { token, userId },
      data: { isActive: false },
    });

    return { message: 'Device token unregistered successfully' };
  }

  /**
   * Get active device tokens for a user.
   */
  async getUserActiveTokens(userId: string) {
    return prisma.deviceToken.findMany({
      where: { userId, isActive: true },
    });
  }
}
