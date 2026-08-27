//
//  AuditLogs.tsx
//  RiseAdmin
//
//  SOC2 and GDPR compliance security audit trail of all admin operations
//

import React from 'react';

export const AuditLogs: React.FC = () => {
  const logs = [
    { id: '1', timestamp: '2026-08-26 19:00:14 UTC', admin: 'admin@riseapp.com', action: 'CREATE_QUOTE', details: 'Added Stoicism quote by Marcus Aurelius (Day 1)', ip: '192.168.1.1' },
    { id: '2', timestamp: '2026-08-26 18:45:02 UTC', admin: 'admin@riseapp.com', action: 'GRANT_PRO', details: 'Granted LIFETIME subscription to alex@example.com', ip: '192.168.1.1' },
    { id: '3', timestamp: '2026-08-26 17:30:20 UTC', admin: 'admin@riseapp.com', action: 'BROADCAST_PUSH', details: 'Dispatched APNs alert to 890 active devices', ip: '192.168.1.1' },
  ];

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Security & Audit Trail</h1>
          <p className="view-subtitle">Immutable log of all administrative actions, content releases, and entitlement overrides</p>
        </div>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Audit Trail Records</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Administrator</th>
              <th>Action Code</th>
              <th>Operational Details</th>
              <th>IP Address</th>
            </tr>
          </thead>
          <tbody>
            {logs.map((l) => (
              <tr key={l.id}>
                <td style={{ fontFamily: 'monospace', fontSize: '11px' }}>{l.timestamp}</td>
                <td style={{ fontWeight: 600, color: '#fff' }}>{l.admin}</td>
                <td><span className="pill-badge pill-amber">{l.action}</span></td>
                <td>{l.details}</td>
                <td style={{ fontFamily: 'monospace', fontSize: '11px', color: '#64748b' }}>{l.ip}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
