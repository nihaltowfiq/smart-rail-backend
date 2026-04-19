export interface JwtPayload {
  user_id: number;
  role: 'user' | 'admin';
}
