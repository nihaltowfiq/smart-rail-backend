import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { BookingsModule } from './bookings/bookings.module';
import { TrainsModule } from './trains/trains.module';

@Module({
  imports: [AuthModule, TrainsModule, BookingsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
