import { Injectable } from '@nestjs/common';
import { db } from '../config/database.config';

@Injectable()
export class DbService {
  async query<T>(sql: string, params?: any[]): Promise<T> {
    const [rows] = await db.query(sql, params);
    return rows as T;
  }
}
