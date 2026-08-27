import nodemailer from 'nodemailer';
import { env } from '@/config/env.js';
import { logger } from '@/utils/logger.js';

export interface EmailOptions {
  to: string;
  subject: string;
  html: string;
  text?: string;
}

export class EmailService {
  private transporter: nodemailer.Transporter | null = null;

  constructor() {
    // Configure Brevo / standard SMTP transporter if credentials exist
    const smtpHost = process.env.SMTP_HOST || 'smtp-relay.brevo.com';
    const smtpPort = Number(process.env.SMTP_PORT) || 587;
    const smtpUser = process.env.SMTP_USER;
    const smtpPass = process.env.SMTP_PASS;

    if (smtpUser && smtpPass) {
      this.transporter = nodemailer.createTransport({
        host: smtpHost,
        port: smtpPort,
        secure: smtpPort === 465,
        auth: {
          user: smtpUser,
          pass: smtpPass,
        },
      });
      logger.info({ host: smtpHost, port: smtpPort, user: smtpUser }, '📧 Nodemailer SMTP Transporter initialized (Brevo/SMTP)');
    }
  }

  /**
   * Dispatch an email via Brevo SMTP, Brevo API, Resend, or fallback logger.
   */
  async sendEmail(options: EmailOptions): Promise<boolean> {
    logger.info({ to: options.to, subject: options.subject }, '✉️ Dispatching transactional email');
    const fromAddress = process.env.EMAIL_FROM || process.env.SMTP_USER || 'Rise <auth@riseapp.com>';

    // 1. Brevo / Nodemailer SMTP Dispatch
    if (this.transporter) {
      try {
        const info = await this.transporter.sendMail({
          from: fromAddress,
          to: options.to,
          subject: options.subject,
          html: options.html,
          text: options.text,
        });
        logger.info({ to: options.to, messageId: info.messageId }, '✅ Email delivered via Brevo SMTP');
        return true;
      } catch (error) {
        logger.error({ error }, 'Failed to deliver email via Brevo SMTP');
      }
    }

    // 2. Brevo Direct REST API Dispatch (if BREVO_API_KEY is configured)
    const brevoApiKey = process.env.BREVO_API_KEY;
    if (brevoApiKey) {
      try {
        const response = await fetch('https://api.brevo.com/v3/smtp/email', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'api-key': brevoApiKey,
          },
          body: JSON.stringify({
            sender: { name: 'Rise', email: process.env.EMAIL_FROM || 'auth@riseapp.com' },
            to: [{ email: options.to }],
            subject: options.subject,
            htmlContent: options.html,
            textContent: options.text,
          }),
        });

        if (response.ok) {
          logger.info({ to: options.to }, '✅ Live email delivered via Brevo REST API');
          return true;
        } else {
          const errorDetails = await response.text();
          logger.warn({ errorDetails }, 'Brevo REST API dispatch error');
        }
      } catch (error) {
        logger.error({ error }, 'Failed to dispatch email via Brevo API');
      }
    }

    // 3. Resend API Provider Dispatch (if RESEND_API_KEY is configured)
    const resendApiKey = process.env.RESEND_API_KEY;
    if (resendApiKey) {
      try {
        const response = await fetch('https://api.resend.com/emails', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${resendApiKey}`,
          },
          body: JSON.stringify({
            from: fromAddress,
            to: [options.to],
            subject: options.subject,
            html: options.html,
            text: options.text,
          }),
        });

        if (response.ok) {
          logger.info({ to: options.to }, '✅ Live email delivered via Resend');
          return true;
        }
      } catch (error) {
        logger.error({ error }, 'Failed to dispatch email via Resend API');
      }
    }

    // 4. Sandbox logger mode
    logger.info({ to: options.to, subject: options.subject }, 'Email generated (Console Sandbox Mode)');
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

  /**
   * Send Rise-branded 6-digit Email Verification OTP code.
   */
  async sendOTPEmail(toEmail: string, name: string, otpCode: string): Promise<boolean> {
    const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Rise verification code</title>
  <style>
    body { margin: 0; padding: 0; background-color: #090616; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #FFFFFF; }
    .wrapper { width: 100%; max-width: 520px; margin: 40px auto; padding: 36px 28px; background: #12102D; border: 1px solid rgba(255, 255, 255, 0.12); border-radius: 24px; text-align: center; }
    .logo { font-size: 26px; font-weight: 800; color: #FFD868; margin-bottom: 20px; letter-spacing: -0.5px; }
    .title { font-size: 22px; font-weight: 700; color: #FFFFFF; margin-bottom: 12px; }
    .text { font-size: 15px; line-height: 24px; color: #A1A1AA; margin-bottom: 28px; text-align: left; }
    .otp-box { display: inline-block; padding: 18px 36px; background: #1A1638; border: 2px solid #F59E0B; border-radius: 16px; font-size: 36px; font-weight: 800; letter-spacing: 8px; color: #FFD868; margin: 12px 0 28px 0; }
    .footer { margin-top: 32px; font-size: 12px; color: #71717A; text-align: center; line-height: 18px; }
  </style>
</head>
<body>
  <div class="wrapper">
    <div class="logo">☀️ Rise</div>
    <div class="title">Verify Your Email Address</div>
    <div class="text">
      Hi ${name || 'Friend'},<br><br>
      Thank you for joining Rise. Please enter the 6-digit verification code below in your app to activate your account. This code expires in <strong>10 minutes</strong>.
    </div>
    <div class="otp-box">${otpCode}</div>
    <div class="text" style="font-size: 13px; text-align: center; color: #71717A;">
      If you did not request this code, you can safely ignore this email.
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
      subject: `${otpCode} is your Rise verification code`,
      html,
      text: `Your Rise verification code is ${otpCode}. It expires in 10 minutes.`,
    });
  }
}
