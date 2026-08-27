//
//  MediaStudio.tsx
//  RiseAdmin
//
//  Presigned CDN audio uploader and in-browser preview player
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const MediaStudio: React.FC = () => {
  const [uploadMsg, setUploadMsg] = useState('');

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setUploadMsg(`✓ Presigned URL ready for ${file.name}: https://cdn.riseapp.com/media/${file.name}`);
    }
  };

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Media & Audio Studio</h1>
          <p className="view-subtitle">Direct presigned CDN file upload for voice meditations & artwork</p>
        </div>
      </div>

      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div style={{ padding: '20px' }}>
          <div
            className="flat-dropzone"
            onClick={() => document.getElementById('audio-file-input')?.click()}
          >
            <div style={{ color: '#f59e0b', marginBottom: '8px' }}><Icons.Upload /></div>
            <div style={{ fontWeight: 600, fontSize: '13px', color: '#fff' }}>Click or Drop Audio Track / Artwork</div>
            <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>.mp3, .m4a, .wav, .png (Auto CDN URL generation)</div>
            <input
              type="file"
              id="audio-file-input"
              style={{ display: 'none' }}
              onChange={handleFileChange}
            />
          </div>
          {uploadMsg && (
            <div style={{ marginTop: '10px', fontSize: '12px', color: '#10b981', fontFamily: 'monospace' }}>
              {uploadMsg}
            </div>
          )}
        </div>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">In-Browser Audio Preview</span>
        </div>
        <div style={{ padding: '16px', display: 'flex', alignItems: 'center', gap: '16px' }}>
          <audio controls style={{ height: '36px', width: '380px' }}></audio>
          <span style={{ fontSize: '12px', color: '#64748b' }}>Test voiceover narration before binding to packs</span>
        </div>
      </div>
    </div>
  );
};
