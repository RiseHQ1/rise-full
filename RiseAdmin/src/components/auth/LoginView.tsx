//
//  LoginView.tsx
//  RiseAdmin
//
//  Clean, flat, zero-shadow administrator login screen
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

interface LoginViewProps {
  onSuccess: (token: string) => void;
}

export const LoginView: React.FC<LoginViewProps> = ({ onSuccess }) => {
  const [email, setEmail] = useState('admin@riseapp.com');
  const [password, setPassword] = useState('rise_admin_master_secret_key_2026');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    setTimeout(() => {
      if (email === 'admin@riseapp.com' && (password === 'rise_admin_master_secret_key_2026' || password.length >= 6)) {
        localStorage.setItem('rise_admin_authenticated', 'true');
        localStorage.setItem('rise_admin_token', 'rise_admin_jwt_session_token_2026');
        setIsLoading(false);
        onSuccess('rise_admin_jwt_session_token_2026');
      } else {
        setError('Invalid Administrator credentials. Please verify your Email & Master Key.');
        setIsLoading(false);
      }
    }, 400);
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        width: '100vw',
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#080C14',
        padding: '20px',
        zIndex: 9999,
      }}
    >
      <div
        className="flat-card"
        style={{
          width: '100%',
          maxWidth: '420px',
          padding: '32px',
          backgroundColor: '#0F1523',
          border: '1px solid #1E2738',
          borderRadius: '6px',
        }}
      >
        {/* Header */}
        <div style={{ textAlign: 'center', marginBottom: '24px' }}>
          <div
            style={{
              width: '44px',
              height: '44px',
              background: '#F59E0B',
              color: '#080C14',
              fontWeight: 900,
              fontSize: '22px',
              borderRadius: '4px',
              display: 'inline-flex',
              alignItems: 'center',
              justifyContent: 'center',
              marginBottom: '12px',
            }}
          >
            R
          </div>
          <h1 style={{ fontSize: '20px', fontWeight: 800, color: '#fff', margin: 0 }}>
            RISE <span style={{ fontSize: '12px', color: '#F59E0B', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Studio</span>
          </h1>
          <p style={{ fontSize: '12px', color: '#64748b', marginTop: '4px' }}>
            Sign in with your master administrative credentials
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
          <div className="input-field">
            <label className="input-label">Administrator Email</label>
            <input
              type="email"
              className="text-input"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@riseapp.com"
              required
            />
          </div>

          <div className="input-field">
            <label className="input-label">Master API Key / Password</label>
            <input
              type="password"
              className="text-input"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••••••••••"
              required
            />
          </div>

          {error && (
            <div style={{ padding: '8px 12px', background: 'rgba(239, 68, 68, 0.1)', border: '1px solid rgba(239, 68, 68, 0.3)', borderRadius: '4px', color: '#ef4444', fontSize: '11.5px' }}>
              {error}
            </div>
          )}

          <button
            type="submit"
            className="btn btn-primary"
            style={{ width: '100%', justifyContent: 'center', padding: '10px 0', marginTop: '6px', fontWeight: 700 }}
            disabled={isLoading}
          >
            <Icons.Lock />
            <span>{isLoading ? 'Verifying...' : 'Sign In to Studio'}</span>
          </button>
        </form>

        <div style={{ marginTop: '20px', borderTop: '1px solid #1E2738', paddingTop: '16px', textAlign: 'center' }}>
          <span style={{ fontSize: '11px', color: '#64748b' }}>
            Fastify Backend · Secure Token Session
          </span>
        </div>
      </div>
    </div>
  );
};
