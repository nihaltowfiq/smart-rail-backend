/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import {
  Body,
  Controller,
  Post,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { GetUser } from 'src/libs/get.user.decorator';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/bookings.dto';
@ApiTags('Bookings')
@UseGuards(AuthGuard)
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post('/')
  @ApiOperation({ summary: 'Search Trains' })
  // @UsePipes(new ValidationPipe({ whitelist: true }))
  async createBooking(@Body() dto: CreateBookingDto, @GetUser() user) {
    // Assumes you have auth middleware that sets req.user
    const userId = user?.user_id;
    return this.bookingsService.createBooking(dto, userId);
  }

  @Post('/test')
  @UsePipes(new ValidationPipe({ whitelist: true }))
  async makeBooking(@Body() dto: CreateBookingDto, @GetUser() user) {
    // Assumes you have auth middleware that sets req.user
    const userId = user?.id;

    console.log(userId);
    if (!userId) {
      throw new Error('Unauthorized');
    }

    return this.bookingsService.createBooking(dto, userId);
  }
}
