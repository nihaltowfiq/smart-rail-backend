/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { BadRequestException, Injectable } from '@nestjs/common';
import { db } from 'src/config/database.config';
import { GetTrainsFilterDto, TrainListResponse } from './dto/get-trains.dto';

@Injectable()
export class AdminService {
  async getTrainsWithIncome(
    filter: GetTrainsFilterDto,
  ): Promise<TrainListResponse> {
    const page = filter.page || 1;
    const limit = filter.limit || 10;
    const offset = (page - 1) * limit;

    // Build date filter based on incomeFilter parameter
    let dateFilter = '';
    const params: any[] = [];

    if (filter.incomeFilter === 'YEAR') {
      const year = filter.year || new Date().getFullYear();
      dateFilter = `AND YEAR(b.created_at) = ?`;
      params.push(year);
    } else if (filter.incomeFilter === 'MONTH') {
      const now = new Date();
      const year = filter.year || now.getFullYear();
      const month = filter.month || now.getMonth() + 1;

      if (month < 1 || month > 12) {
        throw new BadRequestException('Month must be between 1 and 12');
      }

      dateFilter = `AND YEAR(b.created_at) = ? AND MONTH(b.created_at) = ?`;
      params.push(year, month);
    }
    // For ALL_TIME, dateFilter remains empty

    // Build search filters
    let searchFilter = '';
    if (filter.trainName) {
      searchFilter += ` AND t.train_name LIKE ?`;
      params.push(`%${filter.trainName}%`);
    }
    if (filter.trainNumber) {
      searchFilter += ` AND t.train_number LIKE ?`;
      params.push(`%${filter.trainNumber}%`);
    }

    // Get total count
    const countQuery = `
      SELECT COUNT(DISTINCT t.train_id) as total
      FROM trains t
      LEFT JOIN schedules s ON s.train_id = t.train_id
      LEFT JOIN bookings b ON b.schedule_id = s.schedule_id
      LEFT JOIN booking_seats bs ON bs.booking_id = b.booking_id
      LEFT JOIN payments p ON p.booking_id = b.booking_id
      WHERE 1=1
      ${dateFilter}
      ${searchFilter}
    `;

    const [countResult]: any = await db.query(countQuery, params);
    const total = countResult[0]?.total || 0;
    const pages = Math.ceil(total / limit);

    // Build sort clause
    const sortBy = filter.sortBy || 'name';
    const sortOrder = filter.sortOrder || 'ASC';
    let orderBy = 'ORDER BY t.train_name ASC';

    if (sortBy === 'number') {
      orderBy = `ORDER BY t.train_number ${sortOrder}`;
    } else if (sortBy === 'income') {
      orderBy = `ORDER BY totalIncome ${sortOrder}`;
    } else if (sortBy === 'bookings') {
      orderBy = `ORDER BY totalBookings ${sortOrder}`;
    } else {
      orderBy = `ORDER BY t.train_name ${sortOrder}`;
    }

    // Main query with pagination
    const query = `
      SELECT 
        t.train_id,
        t.train_name,
        t.train_number,
        COALESCE(SUM(CASE WHEN p.status = 'SUCCESS' THEN p.amount ELSE 0 END), 0) as totalIncome,
        COUNT(DISTINCT b.booking_id) as totalBookings,
        COUNT(DISTINCT CASE WHEN p.status = 'SUCCESS' THEN p.payment_id END) as successfulPayments,
        COALESCE(SUM(b.seat_count), 0) as totalPassengers
      FROM trains t
      LEFT JOIN schedules s ON s.train_id = t.train_id
      LEFT JOIN bookings b ON b.schedule_id = s.schedule_id
      LEFT JOIN booking_seats bs ON bs.booking_id = b.booking_id
      LEFT JOIN payments p ON p.booking_id = b.booking_id
      WHERE 1=1
      ${dateFilter}
      ${searchFilter}
      GROUP BY t.train_id, t.train_name, t.train_number
      ${orderBy}
      LIMIT ? OFFSET ?
    `;

    params.push(limit, offset);

    const [rows]: any = await db.query(query, params);

    return {
      trains: rows.map((row: any) => ({
        trainId: row.train_id,
        trainName: row.train_name,
        trainNumber: row.train_number,
        totalIncome: parseFloat(row.totalIncome) || 0,
        totalBookings: row.totalBookings || 0,
        successfulPayments: row.successfulPayments || 0,
        totalPassengers: row.totalPassengers || 0,
      })),
      pagination: {
        page,
        limit,
        total,
        pages,
      },
    };
  }

  async getTrainDetailedStats(trainId: number) {
    const query = `
      SELECT 
        t.train_id,
        t.train_name,
        t.train_number,
        COUNT(DISTINCT s.schedule_id) as totalSchedules,
        COUNT(DISTINCT tc.coach_id) as totalCoaches,
        COUNT(DISTINCT st.seat_id) as totalSeats,
        COUNT(DISTINCT b.booking_id) as totalBookings,
        COUNT(DISTINCT CASE WHEN b.status = 'CONFIRMED' THEN b.booking_id END) as confirmedBookings,
        COALESCE(SUM(CASE WHEN p.status = 'SUCCESS' THEN p.amount ELSE 0 END), 0) as totalIncome,
        COALESCE(AVG(CASE WHEN p.status = 'SUCCESS' THEN p.amount END), 0) as avgTransactionValue
      FROM trains t
      LEFT JOIN schedules s ON s.train_id = t.train_id
      LEFT JOIN train_coaches tc ON tc.train_id = t.train_id
      LEFT JOIN seats st ON st.coach_id = tc.coach_id
      LEFT JOIN bookings b ON b.schedule_id = s.schedule_id
      LEFT JOIN payments p ON p.booking_id = b.booking_id
      WHERE t.train_id = ?
      GROUP BY t.train_id, t.train_name, t.train_number
    `;

    const [rows]: any = await db.query(query, [trainId]);

    if (rows.length === 0) {
      return null;
    }

    const row = rows[0];
    return {
      trainId: row.train_id,
      trainName: row.train_name,
      trainNumber: row.train_number,
      stats: {
        totalSchedules: row.totalSchedules || 0,
        totalCoaches: row.totalCoaches || 0,
        totalSeats: row.totalSeats || 0,
        totalBookings: row.totalBookings || 0,
        confirmedBookings: row.confirmedBookings || 0,
        totalIncome: parseFloat(row.totalIncome) || 0,
        avgTransactionValue: parseFloat(row.avgTransactionValue) || 0,
      },
    };
  }

  async getIncomeByPaymentMethod(
    trainId?: number,
    incomeFilter: 'ALL_TIME' | 'YEAR' | 'MONTH' = 'ALL_TIME',
    year?: number,
    month?: number,
  ) {
    let dateFilter = '';
    const params: any[] = [];

    if (incomeFilter === 'YEAR') {
      const filterYear = year || new Date().getFullYear();
      dateFilter = `AND YEAR(p.payment_date) = ?`;
      params.push(filterYear);
    } else if (incomeFilter === 'MONTH') {
      const now = new Date();
      const filterYear = year || now.getFullYear();
      const filterMonth = month || now.getMonth() + 1;

      if (filterMonth < 1 || filterMonth > 12) {
        throw new BadRequestException('Month must be between 1 and 12');
      }

      dateFilter = `AND YEAR(p.payment_date) = ? AND MONTH(p.payment_date) = ?`;
      params.push(filterYear, filterMonth);
    }

    let trainFilter = '';
    if (trainId) {
      trainFilter = `AND t.train_id = ?`;
      params.push(trainId);
    }

    const query = `
      SELECT 
        p.payment_method,
        COUNT(p.payment_id) as transactionCount,
        SUM(CASE WHEN p.status = 'SUCCESS' THEN p.amount ELSE 0 END) as totalIncome,
        COUNT(CASE WHEN p.status = 'SUCCESS' THEN p.payment_id END) as successCount,
        COUNT(CASE WHEN p.status = 'FAILED' THEN p.payment_id END) as failedCount,
        COUNT(CASE WHEN p.status = 'PENDING' THEN p.payment_id END) as pendingCount
      FROM payments p
      JOIN bookings b ON b.booking_id = p.booking_id
      JOIN schedules s ON s.schedule_id = b.schedule_id
      JOIN trains t ON t.train_id = s.train_id
      WHERE p.status IN ('SUCCESS', 'FAILED', 'PENDING')
      ${trainFilter}
      ${dateFilter}
      GROUP BY p.payment_method
    `;

    const [rows]: any = await db.query(query, params);

    return rows.map((row: any) => ({
      paymentMethod: row.payment_method,
      transactionCount: row.transactionCount,
      totalIncome: parseFloat(row.totalIncome) || 0,
      successCount: row.successCount,
      failedCount: row.failedCount,
      pendingCount: row.pendingCount,
    }));
  }
}
