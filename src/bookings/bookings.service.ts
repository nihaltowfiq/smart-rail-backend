/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { db } from 'src/config/database.config';
import { CreateBookingDto } from './dto/bookings.dto';

@Injectable()
export class BookingsService {
  async createBooking(dto: CreateBookingDto, userId: number) {
    if (dto.seatIds.length > 5) {
      throw new BadRequestException('Max 5 seats allowed');
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
        throw new BadRequestException('Some seats already booked');
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

  async getBookingDetails(bookingId: number) {
    const [rows]: any = await db.query(
      `
        SELECT 
          b.booking_id,
          b.total_amount,
          b.status AS booking_status,
          b.journey_date,
          b.class_type,

          u.user_id,
          u.name,

          t.train_name,
          t.train_number,

          s.departure_time,
          s.arrival_time,

          st1.station_name AS source,
          st2.station_name AS destination,

          tc.coach_label,
          se.seat_number,

          p.status AS payment_status,
          p.transaction_id

        FROM bookings b
        JOIN users u ON u.user_id = b.user_id
        JOIN schedules s ON s.schedule_id = b.schedule_id
        JOIN trains t ON t.train_id = s.train_id
        JOIN routes r ON r.route_id = s.route_id
        JOIN stations st1 ON st1.station_id = r.source_station_id
        JOIN stations st2 ON st2.station_id = r.destination_station_id

        JOIN booking_seats bs ON bs.booking_id = b.booking_id
        JOIN seats se ON se.seat_id = bs.seat_id
        JOIN train_coaches tc ON tc.coach_id = se.coach_id

        LEFT JOIN payments p ON p.booking_id = b.booking_id

        WHERE b.booking_id = ?
      `,
      [bookingId],
    );

    if (rows.length === 0) throw new NotFoundException('Booking not found');

    const first = rows[0];

    const seats = rows.map((r: any) => `${r.coach_label}-${r.seat_number}`);

    return {
      bookingId: first.booking_id,
      user: {
        user_id: first.user_id,
        name: first.name,
      },
      train: {
        train_name: first.train_name,
        train_number: first.train_number,
      },
      route: {
        from: first.source,
        to: first.destination,
      },
      schedule: {
        departure_time: first.departure_time,
        arrival_time: first.arrival_time,
        journey_date: first.journey_date,
      },
      seats,
      class_type: first.class_type,
      total_amount: first.total_amount,
      booking_status: first.booking_status,
      payment: {
        status: first.payment_status || 'PENDING',
        transaction_id: first.transaction_id || null,
      },
    };
  }

  private generateTransactionId() {
    const random = Math.floor(10000000 + Math.random() * 90000000);
    return `trnx${random}`;
  }

  async makePayment(bookingId: number) {
    const conn = await db.getConnection();
    await conn.beginTransaction();

    try {
      const [[booking]]: any = await conn.query(
        `SELECT * FROM bookings WHERE booking_id = ?`,
        [bookingId],
      );

      if (!booking) throw new NotFoundException('Booking not found');

      if (booking.status === 'CONFIRMED') {
        throw new BadRequestException('Already paid');
      }

      const transactionId = this.generateTransactionId();

      // Check if payment already exists
      const [[existingPayment]]: any = await conn.query(
        `SELECT * FROM payments WHERE booking_id = ?`,
        [bookingId],
      );

      if (existingPayment) {
        await conn.query(
          `
            UPDATE payments
            SET transaction_id = ?, status = 'SUCCESS'
            WHERE booking_id = ?
          `,
          [transactionId, bookingId],
        );
      } else {
        await conn.query(
          `
            INSERT INTO payments (booking_id, transaction_id, amount, status)
            VALUES (?, ?, ?, 'SUCCESS')
          `,
          [bookingId, transactionId, booking.total_amount],
        );
      }

      await conn.query(
        `
          UPDATE bookings
          SET status = 'CONFIRMED'
          WHERE booking_id = ?
        `,
        [bookingId],
      );

      await conn.commit();

      return {
        transactionId,
      };
    } catch (err) {
      await conn.rollback();
      throw err;
    }
  }
}
