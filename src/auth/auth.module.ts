import { Module } from '@nestjs/common';
import { DbService } from 'src/database/db.service';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  controllers: [AuthController],
  providers: [AuthService, DbService],
})
export class AuthModule {}
