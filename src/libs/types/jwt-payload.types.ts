export interface JwtPayload {
  user_id: number;
  role: 'user' | 'admin';
  name: string;
  phone: string;
}
