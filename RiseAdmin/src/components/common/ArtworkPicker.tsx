//
//  ArtworkPicker.tsx
//  RiseAdmin
//
//  Artwork image selector and direct CDN image uploader with live thumbnail preview
//

import React, { useState } from 'react';
import { Icons } from './Icons.js';

interface ArtworkPickerProps {
  label?: string;
  value: string;
  onChange: (artwork: string) => void;
}

const PRESET_ARTWORKS = [
  { id: 'pack_morning_reset', label: 'Morning Sunrise (Gold)', color: '#E5A93C' },
  { id: 'pack_confidence', label: 'Radiant Fire (Amber)', color: '#F97316' },
  { id: 'pack_deep_focus', label: 'Deep Ocean (Indigo)', color: '#6366F1' },
  { id: 'pack_evening_reset', label: 'Midnight Calm (Navy)', color: '#1E1B4B' },
  { id: 'pack_self_love', label: 'Rose Serenity (Rose)', color: '#F43F5E' },
  { id: 'pack_discipline', label: 'Titanium Steel (Slate)', color: '#475569' },
  { id: 'onboarding_motivation_bg', label: 'Stoic Marble Texture', color: '#334155' },
];

export const ArtworkPicker: React.FC<ArtworkPickerProps> = ({
  label = 'Cover Artwork / Background Image',
  value,
  onChange,
}) => {
  const [isUploading, setIsUploading] = useState(false);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setIsUploading(true);
      // Simulate direct CDN presigned upload
      setTimeout(() => {
        setIsUploading(false);
        const cdnUrl = `https://cdn.riseapp.com/artwork/${file.name}`;
        onChange(cdnUrl);
      }, 500);
    }
  };

  return (
    <div className="input-field">
      <label className="input-label">{label}</label>

      <div style={{ display: 'flex', gap: '10px', alignItems: 'center', flexWrap: 'wrap' }}>
        {/* Preset Selector */}
        <select
          className="flat-select"
          value={value.startsWith('http') ? 'custom' : value}
          onChange={(e) => {
            if (e.target.value !== 'custom') {
              onChange(e.target.value);
            }
          }}
          style={{ flex: 1, minWidth: '180px' }}
        >
          {PRESET_ARTWORKS.map((a) => (
            <option key={a.id} value={a.id}>{a.label} ({a.id})</option>
          ))}
          <option value="custom">Custom CDN Image URL</option>
        </select>

        {/* Upload Button Trigger */}
        <button
          type="button"
          className="btn btn-secondary btn-sm"
          onClick={() => document.getElementById(`artwork-uploader-${label}`)?.click()}
        >
          <Icons.Upload size={13} />
          <span>{isUploading ? 'Uploading...' : 'Upload Image'}</span>
        </button>
        <input
          type="file"
          id={`artwork-uploader-${label}`}
          style={{ display: 'none' }}
          accept="image/png,image/jpeg,image/webp"
          onChange={handleFileUpload}
        />
      </div>

      {/* If custom URL, show text input */}
      {value.startsWith('http') && (
        <input
          type="text"
          className="text-input"
          style={{ marginTop: '6px', fontSize: '11px', fontFamily: 'monospace' }}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="https://cdn.riseapp.com/artwork/image.png"
        />
      )}

      {/* Visual Artwork Thumbnail Preview */}
      <div style={{ marginTop: '6px', display: 'flex', alignItems: 'center', gap: '8px' }}>
        <div
          style={{
            width: '38px',
            height: '38px',
            borderRadius: '4px',
            background: value.startsWith('http') ? `url(${value}) center/cover no-repeat` : 'linear-gradient(135deg, #F59E0B 0%, #0F172A 100%)',
            border: '1px solid #1E2738',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '11px',
            color: '#fff',
            fontWeight: 700,
          }}
        >
          {!value.startsWith('http') && 'IMG'}
        </div>
        <span style={{ fontSize: '11px', color: '#64748b', fontFamily: 'monospace' }}>
          Active Artwork Asset: <strong>{value || 'pack_morning_reset'}</strong>
        </span>
      </div>
    </div>
  );
};
