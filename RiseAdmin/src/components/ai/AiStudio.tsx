//
//  AiStudio.tsx
//  RiseAdmin
//
//  AI Prompt Engineering Playground, Safety Guardian & Crisis Log
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const AiStudio: React.FC = () => {
  const [promptType, setPromptType] = useState<'boost' | 'reflection' | 'growth'>('boost');
  const [testUserContext, setTestUserContext] = useState('Feeling overwhelmed by exams, needs focus and calm');
  const [outputResult, setOutputResult] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const crisisLogs = [
    { id: '1', timestamp: '2026-08-26 14:22:10 UTC', matchedTrigger: 'hopeless / end it', action: 'Intercepted before LLM. 988 Crisis Lifeline delivered.', status: 'HANDLED' },
    { id: '2', timestamp: '2026-08-25 09:14:05 UTC', matchedTrigger: 'self harm', action: 'Intercepted before LLM. Crisis Text Line delivered.', status: 'HANDLED' },
  ];

  const handleTestPrompt = () => {
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setOutputResult(
        `"Exams do not measure your worth; they merely test your preparation. Take a slow, grounding breath. Focus not on the mountain of tasks, but on the single deliberate step right in front of you."\n\n— Generated via Rise AI Engine (0.42s latency, 142 tokens)`
      );
    }, 600);
  };

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">AI Engine & Safety Guardian</h1>
          <p className="view-subtitle">System prompt tuning, token usage metering, and intercepted crisis audit logs</p>
        </div>
      </div>

      <div className="kpi-row" style={{ marginBottom: '16px' }}>
        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Daily AI Requests</span>
            <div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Cpu /></div>
          </div>
          <div className="kpi-value">1,840</div>
          <span className="pill-badge pill-indigo">Avg 0.45s Latency</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Token Quota Meter</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div>
          </div>
          <div className="kpi-value">124k / 500k</div>
          <span className="pill-badge pill-emerald">24.8% Capacity</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Crisis Interceptions</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Shield /></div>
          </div>
          <div className="kpi-value">2 Total</div>
          <span className="pill-badge pill-emerald">100% Guarded</span>
        </div>
      </div>

      {/* Prompt Playground */}
      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div className="flat-card-header">
          <span className="card-title">Prompt Engineering Playground</span>
          <div className="filter-row">
            <button
              className={`btn btn-sm ${promptType === 'boost' ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setPromptType('boost')}
            >
              Morning Boost
            </button>
            <button
              className={`btn btn-sm ${promptType === 'reflection' ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setPromptType('reflection')}
            >
              Reflection Insight
            </button>
            <button
              className={`btn btn-sm ${promptType === 'growth' ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setPromptType('growth')}
            >
              Weekly Growth
            </button>
          </div>
        </div>

        <div style={{ padding: '16px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
          <div className="input-field">
            <label className="input-label">User Mood & Focus Context Simulation</label>
            <input
              type="text"
              className="text-input"
              value={testUserContext}
              onChange={(e) => setTestUserContext(e.target.value)}
            />
          </div>
          <button className="btn btn-primary btn-sm" style={{ alignSelf: 'flex-start' }} onClick={handleTestPrompt}>
            {isLoading ? 'Running LLM Inference...' : 'Generate & Test Output'}
          </button>
          {outputResult && (
            <div style={{ background: '#151C2C', border: '1px solid #1E2738', borderRadius: '4px', padding: '14px', whiteSpace: 'pre-wrap', color: '#F8FAFC', fontSize: '12.5px' }}>
              {outputResult}
            </div>
          )}
        </div>
      </div>

      {/* Crisis Interception Audit Log */}
      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">🚨 Safety Guardian: Intercepted Crisis Log</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Timestamp</th>
              <th>Trigger Keyword Pattern</th>
              <th>Safety Action Taken</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {crisisLogs.map((log) => (
              <tr key={log.id}>
                <td style={{ fontFamily: 'monospace', fontSize: '11px' }}>{log.timestamp}</td>
                <td><span className="pill-badge pill-slate">{log.matchedTrigger}</span></td>
                <td style={{ color: '#fff' }}>{log.action}</td>
                <td><span className="pill-badge pill-emerald">{log.status}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
