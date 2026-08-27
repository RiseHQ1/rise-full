//
//  SupportDesk.tsx
//  RiseAdmin
//
//  Customer support desk, in-app user feedback, and device telemetry diagnostics
//

import React, { useState } from 'react';

export const SupportDesk: React.FC = () => {
  const [tickets, setTickets] = useState([
    {
      id: 't_101',
      user: 'elena@example.com',
      subject: 'Audio cuts out after 2 minutes on background',
      type: 'BUG',
      device: 'iPhone 15 Pro · iOS 18.1 · Rise v1.0.2',
      date: '2026-08-26 18:20 UTC',
      status: 'OPEN',
      message: 'Whenever I lock my phone during the Morning Reset Pack audio, the audio session pauses. Please check background audio permissions.',
    },
    {
      id: 't_102',
      user: 'marcus@example.com',
      subject: 'Request: Marcus Aurelius Meditations Pack',
      type: 'FEATURE_REQUEST',
      device: 'iPhone 16 Pro Max · iOS 18.2 · Rise v1.0.4',
      date: '2026-08-26 15:10 UTC',
      status: 'RESOLVED',
      message: 'Love the app! Would really appreciate a full 14-day pack on Marcus Aurelius Meditations with morning quotes.',
    },
    {
      id: 't_103',
      user: 'sarah.k@example.com',
      subject: 'Pro subscription not unlocking immediately',
      type: 'BILLING',
      device: 'iPhone 14 · iOS 17.6 · Rise v1.0.1',
      date: '2026-08-25 21:40 UTC',
      status: 'RESOLVED',
      message: 'Bought the annual plan through Apple App Store. Clicked Restore Purchases and it worked!',
    },
  ]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">User Feedback & Support Desk</h1>
          <p className="view-subtitle">In-app bug reports, feature requests, and anonymous device diagnostics</p>
        </div>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Customer Feedback Inbox ({tickets.length})</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Ticket ID & Date</th>
              <th>User & Subject</th>
              <th>Category</th>
              <th>Device & OS Telemetry</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {tickets.map((t) => (
              <tr key={t.id}>
                <td>
                  <div style={{ fontWeight: 600, color: '#fff' }}>{t.id}</div>
                  <div style={{ fontSize: '11px', color: '#64748b' }}>{t.date}</div>
                </td>
                <td>
                  <div style={{ fontWeight: 600, color: '#fff' }}>{t.subject}</div>
                  <div style={{ fontSize: '11.5px', color: '#94a3b8' }}>{t.user}</div>
                  <div style={{ fontSize: '11px', color: '#64748b', fontStyle: 'italic', marginTop: '4px' }}>"{t.message}"</div>
                </td>
                <td>
                  <span className={`pill-badge ${t.type === 'BUG' ? 'pill-slate' : t.type === 'BILLING' ? 'pill-amber' : 'pill-indigo'}`}>
                    {t.type}
                  </span>
                </td>
                <td style={{ fontFamily: 'monospace', fontSize: '11px' }}>{t.device}</td>
                <td>
                  <span className={`pill-badge ${t.status === 'OPEN' ? 'pill-amber' : 'pill-emerald'}`}>
                    {t.status}
                  </span>
                </td>
                <td>
                  <button
                    className="btn btn-secondary btn-sm"
                    onClick={() => {
                      alert(`Marked ticket ${t.id} as Resolved`);
                      setTickets(tickets.map(item => item.id === t.id ? { ...item, status: 'RESOLVED' } : item));
                    }}
                  >
                    Resolve
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
