/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { Injectable } from '@nestjs/common';
import { db } from 'src/config/database.config';
import { CreateBookingDto } from './dto/bookings.dto';

@Injectable()
export class BookingsService {
  async createBooking(dto: CreateBookingDto, userId: number) {
    if (dto.seatIds.length > 5) {
      throw new Error('Max 5 seats allowed');
    }

    const conn = await db.getConnection();
    await conn.beginTransaction();

    try {
      const [taken]: any = await conn.query(
        `
          SELECT bs.seat_id
          FROM booking_seats bs
          JOIN bookings b ON b.booking_id = bs.booking_id
          WHERE bs.seat_id IN (?)
            AND b.schedule_id = ?
            AND b.journey_date = ?
            AND b.status = 'CONFIRMED'
        `,
        [dto.seatIds, dto.scheduleId, dto.journeyDate],
      );

      if (taken.length > 0) {
        throw new Error('Some seats already booked');
      }

      const [result]: any = await conn.query(
        `
          INSERT INTO bookings
          (user_id, schedule_id, journey_date, class_type, seat_count, total_amount, status)
          VALUES (?, ?, ?, ?, ?, ?, 'PENDING')
        `,
        [
          userId,
          dto.scheduleId,
          dto.journeyDate,
          dto.classType,
          dto.seatIds.length,
          dto.totalAmount,
        ],
      );

      const bookingId = result.insertId;

      const values = dto.seatIds.map((id) => [bookingId, id]);

      await conn.query(
        `INSERT INTO booking_seats (booking_id, seat_id) VALUES ?`,
        [values],
      );

      await conn.commit();

      return { bookingId };
    } catch (err) {
      await conn.rollback();
      throw err;
    }
  }
}
