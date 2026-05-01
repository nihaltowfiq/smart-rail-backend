import { Module } from '@nestjs/common';
import { DbService } from 'src/database/db.service';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  controllers: [AdminController],
  providers: [AdminService, DbService],
})
export class AdminModule {}
