//
//  adminApi.ts
//  RiseAdmin
//
//  API client for interacting with RiseServer backend admin & auth routes
//

import {
  AdminAffirmation,
  AdminPack,
  AdminQuote,
  AdminUser,
  ApiResponse,
  PlatformSummary,
} from '../types/admin.types';

const API_BASE = '/api/v1';

class AdminApiClient {
  private getAuthToken(): string | null {
    return localStorage.getItem('rise_admin_token');
  }

  public setAuthToken(token: string) {
    localStorage.setItem('rise_admin_token', token);
  }

  public clearAuthToken() {
    localStorage.removeItem('rise_admin_token');
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const token = this.getAuthToken();
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...((options.headers as Record<string, string>) || {}),
    };

    const response = await fetch(`${API_BASE}${endpoint}`, {
      ...options,
      headers,
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data?.error?.message || `Request failed with status ${response.status}`);
    }

    return data;
  }

  // ==========================================
  // Auth
  // ==========================================

  async login(email: string, password: string) {
    const res = await this.request<{ user: AdminUser; tokens: { accessToken: string; refreshToken: string } }>(
      '/auth/login',
      {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      }
    );

    if (res.data?.tokens?.accessToken) {
      this.setAuthToken(res.data.tokens.accessToken);
    }
    return res.data;
  }

  // ==========================================
  // Metrics
  // ==========================================

  async getPlatformSummary() {
    const res = await this.request<PlatformSummary>('/admin/analytics/summary');
    return res.data;
  }

  // ==========================================
  // Packs
  // ==========================================

  async listPacks() {
    const res = await this.request<AdminPack[]>('/admin/packs');
    return res.data;
  }

  async getPack(id: string) {
    const res = await this.request<AdminPack>(`/admin/packs/${id}`);
    return res.data;
  }

  async createPack(pack: Partial<AdminPack>) {
    const res = await this.request<AdminPack>('/admin/packs', {
      method: 'POST',
      body: JSON.stringify(pack),
    });
    return res.data;
  }

  async updatePack(id: string, pack: Partial<AdminPack>) {
    const res = await this.request<AdminPack>(`/admin/packs/${id}`, {
      method: 'PUT',
      body: JSON.stringify(pack),
    });
    return res.data;
  }

  async deletePack(id: string) {
    const res = await this.request<{ message: string }>(`/admin/packs/${id}`, {
      method: 'DELETE',
    });
    return res.data;
  }

  // ==========================================
  // Quotes
  // ==========================================

  async listQuotes(params: { page?: number; limit?: number; search?: string; category?: string } = {}) {
    const query = new URLSearchParams();
    if (params.page) query.set('page', String(params.page));
    if (params.limit) query.set('limit', String(params.limit));
    if (params.search) query.set('search', params.search);
    if (params.category) query.set('category', params.category);

    return this.request<AdminQuote[]>(`/admin/quotes?${query.toString()}`);
  }

  async createQuote(quote: Partial<AdminQuote>) {
    const res = await this.request<AdminQuote>('/admin/quotes', {
      method: 'POST',
      body: JSON.stringify(quote),
    });
    return res.data;
  }

  async updateQuote(id: string, quote: Partial<AdminQuote>) {
    const res = await this.request<AdminQuote>(`/admin/quotes/${id}`, {
      method: 'PUT',
      body: JSON.stringify(quote),
    });
    return res.data;
  }

  async deleteQuote(id: string) {
    const res = await this.request<{ message: string }>(`/admin/quotes/${id}`, {
      method: 'DELETE',
    });
    return res.data;
  }

  // ==========================================
  // Affirmations
  // ==========================================

  async listAffirmations(params: { page?: number; limit?: number; search?: string; category?: string } = {}) {
    const query = new URLSearchParams();
    if (params.page) query.set('page', String(params.page));
    if (params.limit) query.set('limit', String(params.limit));
    if (params.search) query.set('search', params.search);
    if (params.category) query.set('category', params.category);

    return this.request<AdminAffirmation[]>(`/admin/affirmations?${query.toString()}`);
  }

  async createAffirmation(affirmation: Partial<AdminAffirmation>) {
    const res = await this.request<AdminAffirmation>('/admin/affirmations', {
      method: 'POST',
      body: JSON.stringify(affirmation),
    });
    return res.data;
  }

  async updateAffirmation(id: string, affirmation: Partial<AdminAffirmation>) {
    const res = await this.request<AdminAffirmation>(`/admin/affirmations/${id}`, {
      method: 'PUT',
      body: JSON.stringify(affirmation),
    });
    return res.data;
  }

  async deleteAffirmation(id: string) {
    const res = await this.request<{ message: string }>(`/admin/affirmations/${id}`, {
      method: 'DELETE',
    });
    return res.data;
  }

  // ==========================================
  // Users
  // ==========================================

  async listUsers(params: { page?: number; limit?: number; search?: string; tier?: string } = {}) {
    const query = new URLSearchParams();
    if (params.page) query.set('page', String(params.page));
    if (params.limit) query.set('limit', String(params.limit));
    if (params.search) query.set('search', params.search);
    if (params.tier) query.set('tier', params.tier);

    return this.request<AdminUser[]>(`/admin/users?${query.toString()}`);
  }

  async updateUserSubscription(userId: string, input: { subscriptionTier: string; expiresAt?: string | null; role?: string }) {
    const res = await this.request<AdminUser>(`/admin/users/${userId}/subscription`, {
      method: 'PATCH',
      body: JSON.stringify(input),
    });
    return res.data;
  }

  // ==========================================
  // Media Upload Signature
  // ==========================================

  async getUploadSignature(folder: string = 'packs') {
    const res = await this.request<{ signature: string; timestamp: number; apiKey: string; cloudName: string; uploadUrl: string }>(
      '/media/upload-signature',
      {
        method: 'POST',
        body: JSON.stringify({ folder }),
      }
    );
    return res.data;
  }

  // ==========================================
  // Push Broadcast
  // ==========================================

  async broadcastPush(input: { title: string; body: string; category?: string; deepLink?: string }) {
    const res = await this.request<{ message: string }>('/admin/broadcast', {
      method: 'POST',
      body: JSON.stringify(input),
    });
    return res.data;
  }
}

export const adminApi = new AdminApiClient();
