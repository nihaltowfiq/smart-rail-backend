/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { GetUser } from 'src/libs/get.user.decorator';
import { BookingsService } from './bookings.service';
import { CreateBookingDto, PaginationDto } from './dto/bookings.dto';
@ApiTags('Bookings')
@UseGuards(AuthGuard)
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post('/')
  @ApiOperation({ summary: 'Ticket Bookings' })
  async createBooking(@Body() dto: CreateBookingDto, @GetUser() user) {
    const userId = user?.user_id as number;
    return this.bookingsService.createBooking(dto, userId);
  }

  @Get('/list')
  @ApiOperation({ summary: 'Get user bookings with filter & pagination' })
  async getBookingsList(
    @Query('status') status: 'UPCOMING' | 'ALL' | 'PENDING' = 'ALL',
    @Query() query: PaginationDto,
    @GetUser() user,
  ) {
    const userId = user?.user_id as number;

    console.log('RAW QUERY:', query);

    return this.bookingsService.getBookingsList({
      userId,
      status,
      page: query.page || 1,
      limit: query.limit || 10,
    });
  }

  @Get('/:bookingId')
  @ApiOperation({ summary: 'Get booking details by bookingId' })
  async getBooking(@Param('bookingId', ParseIntPipe) bookingId: number) {
    return this.bookingsService.getBookingDetails(bookingId);
  }

  @Post('/payment/:bookingId')
  @ApiOperation({ summary: 'Make payment for a booking' })
  async makePayment(@Param('bookingId', ParseIntPipe) bookingId: number) {
    return this.bookingsService.makePayment(bookingId);
  }
}
