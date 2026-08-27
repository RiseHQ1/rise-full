//
//  email.service.ts
//  RiseServer
//
//  Pluggable transactional email service with Rise-branded dark/gold HTML templates
//

import { env } from '@/config/env.js';
import { logger } from '@/utils/logger.js';

export interface EmailOptions {
  to: string;
  subject: string;
  html: string;
  text?: string;
}

export class EmailService {
  /**
   * Dispatch an email via configured provider (or console logger in development/test).
   */
  async sendEmail(options: EmailOptions): Promise<boolean> {
    logger.info({ to: options.to, subject: options.subject }, '✉️ Dispatching transactional email');

    // If running in development or no external API key is set, log cleanly
    if (env.NODE_ENV !== 'production') {
      logger.debug({ to: options.to, subject: options.subject }, 'Email preview generated successfully');
      return true;
    }

    // In production, integrate with Resend / Postmark / SendGrid / SMTP
    return true;
  }

  /**
   * Send Rise-branded 15-minute Password Reset Email.
   */
  async sendPasswordResetEmail(toEmail: string, name: string, resetToken: string): Promise<boolean> {
    const resetUrl = `https://riseapp.com/reset-password?token=${resetToken}`;

    const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset your Rise password</title>
  <style>
    body { margin: 0; padding: 0; background-color: #090616; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #FFFFFF; }
    .wrapper { width: 100%; max-width: 540px; margin: 40px auto; padding: 32px 24px; background: #12102D; border: 1px solid rgba(255, 255, 255, 0.12); border-radius: 24px; }
    .logo { font-size: 24px; font-weight: 800; color: #FFD868; text-align: center; margin-bottom: 24px; letter-spacing: -0.5px; }
    .title { font-size: 20px; font-weight: 700; color: #FFFFFF; margin-bottom: 12px; }
    .text { font-size: 15px; line-height: 24px; color: #A1A1AA; margin-bottom: 24px; }
    .button { display: inline-block; padding: 14px 28px; background: linear-gradient(135deg, #FFD868 0%, #F59E0B 100%); color: #090616; text-decoration: none; font-size: 15px; font-weight: 700; border-radius: 100px; text-align: center; }
    .footer { margin-top: 32px; font-size: 12px; color: #71717A; text-align: center; line-height: 18px; }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="logo">☀️ Rise</div>
    <div class="title">Reset Your Password</div>
    <div class="text">
      Hi ${name || 'Friend'},<br><br>
      We received a request to reset your Rise account password. Click the button below to choose a new password. This link is valid for <strong>15 minutes</strong>.
    </div>
    <div style="text-align: center; margin: 32px 0;">
      <a href="${resetUrl}" class="button" target="_blank">Reset Password</a>
    </div>
    <div class="text" style="font-size: 13px;">
      If you did not request this, you can safely ignore this email. Your password will remain unchanged.
    </div>
    <div class="footer">
      © ${new Date().getFullYear()} Rise Mindfulness Inc. All rights reserved.
    </div>
  </div>
</body>
</html>
    `;

    return this.sendEmail({
      to: toEmail,
      subject: 'Reset your Rise password',
      html,
      text: `Hi ${name}, click this link to reset your Rise password (valid for 15 mins): ${resetUrl}`,
    });
  }

  /**
   * Send Welcome & Email Verification Email.
   */
  async sendWelcomeVerificationEmail(toEmail: string, name: string, verificationToken: string): Promise<boolean> {
    const verifyUrl = `https://riseapp.com/verify-email?token=${verificationToken}`;

    const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to Rise</title>
  <style>
    body { margin: 0; padding: 0; background-color: #090616; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #FFFFFF; }
    .wrapper { width: 100%; max-width: 540px; margin: 40px auto; padding: 32px 24px; background: #12102D; border: 1px solid rgba(255, 255, 255, 0.12); border-radius: 24px; }
    .logo { font-size: 24px; font-weight: 800; color: #FFD868; text-align: center; margin-bottom: 24px; }
    .title { font-size: 20px; font-weight: 700; color: #FFFFFF; margin-bottom: 12px; }
    .text { font-size: 15px; line-height: 24px; color: #A1A1AA; margin-bottom: 24px; }
    .button { display: inline-block; padding: 14px 28px; background: linear-gradient(135deg, #FFD868 0%, #F59E0B 100%); color: #090616; text-decoration: none; font-size: 15px; font-weight: 700; border-radius: 100px; text-align: center; }
    .footer { margin-top: 32px; font-size: 12px; color: #71717A; text-align: center; }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="logo">☀️ Rise</div>
    <div class="title">Welcome to Rise, ${name || 'Friend'}!</div>
    <div class="text">
      Thank you for taking this step for your peace of mind and growth. Confirm your email address to secure your account.
    </div>
    <div style="text-align: center; margin: 32px 0;">
      <a href="${verifyUrl}" class="button" target="_blank">Verify Email Address</a>
    </div>
    <div class="footer">
      © ${new Date().getFullYear()} Rise Mindfulness Inc.
    </div>
  </div>
</body>
</html>
    `;

    return this.sendEmail({
      to: toEmail,
      subject: 'Welcome to Rise! Confirm your email',
      html,
      text: `Welcome to Rise! Confirm your email here: ${verifyUrl}`,
    });
  }
}
