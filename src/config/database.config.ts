/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import * as mysql from 'mysql2/promise';

export const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '123456',
  database: 'railway_system',
  waitForConnections: true,
  connectionLimit: 10,
});

export async function testDbConnection() {
  try {
    const connection = await db.getConnection();
    console.log('✅ MySQL Connected Successfully');
    connection.release();
  } catch (error: any) {
    console.error('❌ MySQL Connection Failed:', error?.message);
  }
}
