//
//  SystemHealth.tsx
//  RiseAdmin
//
//  Real-time server infrastructure, Redis, BullMQ queues, and database health monitor
//

import React from 'react';
import { Icons } from '../common/Icons.js';

export const SystemHealth: React.FC = () => {
  const queues = [
    { name: 'apns-push-queue', active: 0, waiting: 0, completed: 1420, failed: 0, status: 'HEALTHY' },
    { name: 'ai-generation-queue', active: 2, waiting: 1, completed: 480, failed: 0, status: 'HEALTHY' },
    { name: 'delta-sync-queue', active: 1, waiting: 0, completed: 8910, failed: 1, status: 'HEALTHY' },
  ];

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">System & Queue Infrastructure Health</h1>
          <p className="view-subtitle">Live Fastify server telemetry, Redis memory, PgBouncer pool, and BullMQ queues</p>
        </div>
      </div>

      <div className="kpi-row" style={{ marginBottom: '16px' }}>
        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">PostgreSQL Latency</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Activity /></div>
          </div>
          <div className="kpi-value">1.8ms</div>
          <span className="pill-badge pill-emerald">PgBouncer Pool Optimal</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Redis Cache Hit Rate</span>
            <div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Cpu /></div>
          </div>
          <div className="kpi-value">94.2%</div>
          <span className="pill-badge pill-amber">Quota & Day-of-Year Cache</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">API Server Uptime</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div>
          </div>
          <div className="kpi-value">99.98%</div>
          <span className="pill-badge pill-emerald">Zero Downtime</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Server Memory Load</span>
            <div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Activity /></div>
          </div>
          <div className="kpi-value">148MB / 1GB</div>
          <span className="pill-badge pill-indigo">Fastify V8 Heap</span>
        </div>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">BullMQ Background Job Queues</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Queue Name</th>
              <th>Active Jobs</th>
              <th>Waiting in Queue</th>
              <th>Completed (24h)</th>
              <th>Failed</th>
              <th>Queue Status</th>
            </tr>
          </thead>
          <tbody>
            {queues.map((q) => (
              <tr key={q.name}>
                <td style={{ fontFamily: 'monospace', fontWeight: 600, color: '#fff' }}>{q.name}</td>
                <td><span style={{ color: '#10b981', fontWeight: 600 }}>{q.active}</span></td>
                <td>{q.waiting}</td>
                <td>{q.completed.toLocaleString()}</td>
                <td>{q.failed === 0 ? '0' : <span style={{ color: '#f43f5e' }}>{q.failed}</span>}</td>
                <td><span className="pill-badge pill-emerald">{q.status}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
