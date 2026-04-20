import { BadRequestException, Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';
import { DbService } from 'src/database/db.service';
import { JwtPayload, User } from 'src/libs/types';

@Injectable()
export class AuthService {
  constructor(private db: DbService) {}

  async signup(phone: string, password: string): Promise<{ message: string }> {
    const users = await this.db.query<User[]>(
      'SELECT * FROM users WHERE phone = ?',
      [phone],
    );

    if (users.length > 0) {
      throw new BadRequestException('User already exists');
    }

    const hashed = await bcrypt.hash(password, 10);

    await this.db.query('INSERT INTO users (phone, password) VALUES (?, ?)', [
      phone,
      hashed,
    ]);

    return { message: 'Signup successful' };
  }

  async signin(
    phone: string,
    password: string,
  ): Promise<{
    token: string;
    user: { id: number; phone: string; role: string };
  }> {
    const users = await this.db.query<User[]>(
      'SELECT * FROM users WHERE phone = ?',
      [phone],
    );

    if (users.length === 0) {
      throw new BadRequestException('User not found');
    }

    const user = users[0];

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      throw new BadRequestException('Invalid credentials');
    }

    const payload: JwtPayload = {
      user_id: user.user_id,
      role: user.role,
    };

    const token = jwt.sign(payload, 'SECRET_KEY', {
      expiresIn: '1d',
    });

    return {
      token,
      user: {
        id: user.user_id,
        phone: user.phone,
        role: user.role,
      },
    };
  }
}
