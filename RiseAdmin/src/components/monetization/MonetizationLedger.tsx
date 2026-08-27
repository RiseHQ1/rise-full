//
//  MonetizationLedger.tsx
//  RiseAdmin
//
//  RevenueCat & StoreKit In-App Purchase Analytics & Webhook Event Ledger
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const MonetizationLedger: React.FC = () => {
  const [selectedPayload, setSelectedPayload] = useState<any>(null);

  const transactions = [
    { id: 'tx_108', timestamp: '2026-08-26 18:40:12 UTC', type: 'INITIAL_PURCHASE', product: 'com.riseapp.pro.annual', price: '$29.99', user: 'maya@example.com', status: 'PROCESSED' },
    { id: 'tx_107', timestamp: '2026-08-26 16:15:00 UTC', type: 'RENEWAL', product: 'com.riseapp.pro.monthly', price: '$4.99', user: 'david@example.com', status: 'PROCESSED' },
    { id: 'tx_106', timestamp: '2026-08-26 12:02:44 UTC', type: 'NON_RENEWING_PURCHASE', product: 'com.riseapp.pack.confidence', price: '$2.99', user: 'alex@example.com', status: 'PROCESSED' },
  ];

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Monetization & StoreKit Ledger</h1>
          <p className="view-subtitle">RevenueCat subscriptions, MRR tracking, and live App Store webhook feed</p>
        </div>
      </div>

      <div className="kpi-row" style={{ marginBottom: '16px' }}>
        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Monthly Recurring Revenue</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.CreditCard /></div>
          </div>
          <div className="kpi-value">$8,420</div>
          <span className="pill-badge pill-emerald">+18.4% this month</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Annual Run-Rate (ARR)</span>
            <div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Sparkles /></div>
          </div>
          <div className="kpi-value">$101.4k</div>
          <span className="pill-badge pill-amber">Growing</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Active Free Trials</span>
            <div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Users /></div>
          </div>
          <div className="kpi-value">84 Users</div>
          <span className="pill-badge pill-indigo">7-Day Apple Trial</span>
        </div>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Live RevenueCat Webhook Stream</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Event Type</th>
              <th>StoreKit Product ID</th>
              <th>Amount</th>
              <th>User</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {transactions.map((tx) => (
              <tr key={tx.id}>
                <td style={{ fontFamily: 'monospace', fontSize: '11px' }}>{tx.timestamp}</td>
                <td><span className="pill-badge pill-emerald">{tx.type}</span></td>
                <td style={{ fontFamily: 'monospace', color: '#fff' }}>{tx.product}</td>
                <td style={{ fontWeight: 700 }}>{tx.price}</td>
                <td>{tx.user}</td>
                <td><span className="pill-badge pill-slate">{tx.status}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
