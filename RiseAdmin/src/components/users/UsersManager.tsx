//
//  UsersManager.tsx
//  RiseAdmin
//
//  User profile directory with search, subscription tier filtering, and pagination
//

import React, { useState, useMemo } from 'react';
import { Icons } from '../common/Icons.js';
import { Pagination } from '../common/Pagination.js';
import { AdminUser } from '../../types/admin.types.js';

interface UsersManagerProps {
  users: AdminUser[];
  onGrantPro: (userId: string) => void;
}

export const UsersManager: React.FC<UsersManagerProps> = ({ users, onGrantPro }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [tierFilter, setTierFilter] = useState<string>('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const filtered = useMemo(() => {
    return users.filter((u) => {
      const matchTier = tierFilter === 'ALL' || u.subscriptionTier === tierFilter;
      const matchSearch =
        !searchTerm ||
        u.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        u.email?.toLowerCase().includes(searchTerm.toLowerCase());
      return matchTier && matchSearch;
    });
  }, [users, tierFilter, searchTerm]);

  const paginatedUsers = useMemo(() => {
    const start = (currentPage - 1) * pageSize;
    return filtered.slice(start, start + pageSize);
  }, [filtered, currentPage, pageSize]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">User Oversight & Support Directory</h1>
          <p className="view-subtitle">Search registered profiles, inspect engagement streaks, reflections, and grant entitlement overrides</p>
        </div>
      </div>

      <div className="flat-card">
        {/* Search & Tier Filter Bar */}
        <div className="flat-card-header">
          <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
            <Icons.Search />
            <input
              type="text"
              placeholder="Search by name, email..."
              value={searchTerm}
              onChange={(e) => {
                setSearchTerm(e.target.value);
                setCurrentPage(1);
              }}
            />
          </div>

          <div className="filter-row">
            <select
              className="flat-select"
              value={tierFilter}
              onChange={(e) => {
                setTierFilter(e.target.value);
                setCurrentPage(1);
              }}
            >
              <option value="ALL">All Subscription Tiers</option>
              <option value="FREE">Free Tier</option>
              <option value="PRO_MONTHLY">Pro Monthly</option>
              <option value="PRO_ANNUAL">Pro Annual</option>
              <option value="LIFETIME">Lifetime Pro</option>
            </select>
          </div>
        </div>

        {/* Table */}
        <table className="flat-table">
          <thead>
            <tr>
              <th>User Name & Email</th>
              <th>Subscription Tier</th>
              <th>Streak</th>
              <th>Mindful Minutes</th>
              <th>Reflections</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {paginatedUsers.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: '#64748b' }}>
                  No user accounts found matching query.
                </td>
              </tr>
            ) : (
              paginatedUsers.map((u) => (
                <tr key={u.id}>
                  <td>
                    <div style={{ fontWeight: 600, color: '#fff' }}>{u.name}</div>
                    <div style={{ fontSize: '11px', color: '#64748b' }}>{u.email || 'Apple Sign-In User'}</div>
                  </td>
                  <td>
                    <span className={`pill-badge ${u.subscriptionTier === 'FREE' ? 'pill-slate' : 'pill-amber'}`}>
                      {u.subscriptionTier}
                    </span>
                  </td>
                  <td style={{ color: '#f59e0b', fontWeight: 600 }}>🔥 {u.streak} Days</td>
                  <td>{u.mindfulMinutes}m</td>
                  <td>{u.journalCount} entries</td>
                  <td>
                    <button
                      className="btn btn-secondary btn-sm"
                      onClick={() => onGrantPro(u.id)}
                      disabled={u.subscriptionTier === 'LIFETIME'}
                    >
                      {u.subscriptionTier === 'LIFETIME' ? '✓ Lifetime Active' : 'Grant Lifetime Pro'}
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>

        {/* Pagination Controls */}
        <Pagination
          currentPage={currentPage}
          totalItems={filtered.length}
          pageSize={pageSize}
          onPageChange={setCurrentPage}
          onPageSizeChange={(size) => {
            setPageSize(size);
            setCurrentPage(1);
          }}
        />
      </div>
    </div>
  );
};
