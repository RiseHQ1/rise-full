//
//  CampaignsStudio.tsx
//  RiseAdmin
//
//  Automated Lifecycle Notification Drips & Behavioral Triggers
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const CampaignsStudio: React.FC = () => {
  const [campaigns, setCampaigns] = useState([
    {
      id: 'cmp_01',
      name: 'Evening Streak Rescue',
      trigger: 'No intention logged by 8:00 PM local time',
      action: 'Send push: "Don\'t break the chain! 1 minute to reflect & protect your streak 🔥"',
      status: 'ACTIVE',
      dispatchedToday: 142,
    },
    {
      id: 'cmp_02',
      name: 'Trial Expiration 24h Warning',
      trigger: 'Apple 7-Day Free Trial expires in 24 hours',
      action: 'Send push: "Your Rise Pro access renews tomorrow. Keep 500+ deep audio meditations unlocked 🌅"',
      status: 'ACTIVE',
      dispatchedToday: 18,
    },
    {
      id: 'cmp_03',
      name: 'Sunday Morning Growth Digest',
      trigger: 'Every Sunday at 9:00 AM local time',
      action: 'Send push: "Your weekly mindful reflection summary is ready to view 📈"',
      status: 'ACTIVE',
      dispatchedToday: 0,
    },
  ]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Automated Lifecycle Campaigns</h1>
          <p className="view-subtitle">Event-driven push triggers and retention drip sequences</p>
        </div>
        <button className="btn btn-primary btn-sm" onClick={() => alert('New Automated Campaign builder ready.')}>
          <Icons.Plus />
          <span>New Sequence</span>
        </button>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Active Behavioral Sequences ({campaigns.length})</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Campaign Name</th>
              <th>Behavioral Trigger Condition</th>
              <th>Notification Payload Template</th>
              <th>Dispatched Today</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {campaigns.map((c) => (
              <tr key={c.id}>
                <td style={{ fontWeight: 600, color: '#fff' }}>{c.name}</td>
                <td><span className="pill-badge pill-indigo">{c.trigger}</span></td>
                <td style={{ fontSize: '11.5px', color: '#94a3b8', maxWidth: '300px' }}>{c.action}</td>
                <td style={{ fontWeight: 600, color: '#f59e0b' }}>{c.dispatchedToday} alerts</td>
                <td><span className="pill-badge pill-emerald">{c.status}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
