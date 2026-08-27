//
//  Topbar.tsx
//  RiseAdmin
//
//  Clean, flat top navigation bar with search and quick actions
//

import React from 'react';
import { Icons } from '../common/Icons.js';

interface TopbarProps {
  onQuickCreate: () => void;
}

export const Topbar: React.FC<TopbarProps> = ({ onQuickCreate }) => {
  return (
    <header className="topbar">
      <div className="search-input-group">
        <Icons.Search />
        <input type="text" placeholder="Search catalog, packs, users..." />
        <kbd>⌘K</kbd>
      </div>

      <div className="topbar-right">
        <div className="status-pill">
          <span className="status-dot"></span>
          <span>API :3000</span>
        </div>
        <button className="btn btn-primary btn-sm" onClick={onQuickCreate}>
          <Icons.Plus />
          <span>Create</span>
        </button>
      </div>
    </header>
  );
};
