//
//  PushBroadcaster.tsx
//  RiseAdmin
//
//  APNs Global Push Broadcaster form
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

interface PushBroadcasterProps {
  onSendBroadcast: (payload: { title: string; body: string; deepLink: string }) => void;
}

export const PushBroadcaster: React.FC<PushBroadcasterProps> = ({ onSendBroadcast }) => {
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [deepLink, setDeepLink] = useState('rise://home');

  const handleSend = () => {
    if (!title || !body) {
      alert('Please fill in both title and body.');
      return;
    }
    onSendBroadcast({ title, body, deepLink });
    setTitle('');
    setBody('');
  };

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">APNs Global Push Broadcaster</h1>
          <p className="view-subtitle">Send instant announcement push alerts to all active iOS devices</p>
        </div>
      </div>

      <div className="flat-card" style={{ maxWidth: '540px' }}>
        <div className="flat-card-header">
          <span className="card-title">Compose Push Notification</span>
        </div>
        <div style={{ padding: '18px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
          <div className="input-field">
            <label className="input-label">Notification Title</label>
            <input
              type="text"
              className="text-input"
              placeholder="e.g. Sunrise Reset Ready 🌅"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            />
          </div>
          <div className="input-field">
            <label className="input-label">Message Body</label>
            <textarea
              className="textarea-input"
              rows={3}
              placeholder="Take 3 minutes to ground your mind..."
              value={body}
              onChange={(e) => setBody(e.target.value)}
            ></textarea>
          </div>
          <div className="input-field">
            <label className="input-label">Deep Link URI</label>
            <input
              type="text"
              className="text-input"
              value={deepLink}
              onChange={(e) => setDeepLink(e.target.value)}
            />
          </div>
          <button
            className="btn btn-primary btn-sm"
            style={{ marginTop: '6px' }}
            onClick={handleSend}
          >
            <Icons.Bell />
            <span>Dispatch Push Broadcast</span>
          </button>
        </div>
      </div>
    </div>
  );
};
