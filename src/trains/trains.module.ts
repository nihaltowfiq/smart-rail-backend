import { Module } from '@nestjs/common';
import { DbService } from 'src/database/db.service';
import { TrainsController } from './trains.controller';
import { TrainsService } from './trains.service';

@Module({
  controllers: [TrainsController],
  providers: [TrainsService, DbService],
})
export class TrainsModule {}
