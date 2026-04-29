/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
import { Injectable } from '@nestjs/common';
import { DbService } from 'src/database/db.service';
import { SearchTrainDto } from './dto/search-train.dto';

function getDayOfWeek(date: string): string {
  const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  return days[new Date(date).getDay()];
}

@Injectable()
export class TrainsService {
  constructor(private db: DbService) {}

  private groupSeats(rows: any[]) {
    const map = {};

    for (const r of rows) {
      if (!map[r.coach_id]) {
        map[r.coach_id] = {
          coachId: r.coach_id,
          coachLabel: r.coach_label,
          classType: r.class_type,
          seats: [],
        };
      }

      map[r.coach_id].seats.push({
        seatId: r.seat_id,
        number: r.seat_number,
        status: r.status,
      });
    }

    return Object.values(map);
  }

  async search(dto: SearchTrainDto) {
    const dayOfWeek = getDayOfWeek(dto.date);

    const query = `
    SELECT 
      t.train_id,
      t.train_name,
      t.train_number,
      s.schedule_id,
      s.departure_time,
      s.arrival_time,
      src.station_name AS from_station,
      dest.station_name AS to_station,
      tc.class_type,

      MAX(r.distance_km * fr.price_per_km) AS fare,

      COUNT(DISTINCT st.seat_id) AS total_seat_count,

      COUNT(DISTINCT st.seat_id) - COUNT(DISTINCT bs.seat_id) AS total_available_seats_count

    FROM schedules s
    JOIN trains t ON t.train_id = s.train_id
    JOIN routes r ON r.route_id = s.route_id
    JOIN stations src ON src.station_id = r.source_station_id
    JOIN stations dest ON dest.station_id = r.destination_station_id

    JOIN train_running_days trd 
      ON trd.train_id = t.train_id

    JOIN train_coaches tc 
      ON tc.train_id = t.train_id

    JOIN seats st 
      ON st.coach_id = tc.coach_id

    JOIN fare_rules fr 
      ON fr.class_type = tc.class_type

    LEFT JOIN booking_seats bs 
      ON bs.seat_id = st.seat_id

    LEFT JOIN bookings b 
      ON b.booking_id = bs.booking_id
      AND b.schedule_id = s.schedule_id
      AND b.journey_date = ?
      AND b.status = 'CONFIRMED'

    WHERE 
      src.city = ?
      AND dest.city = ?
      AND trd.day_of_week = ?
      AND trd.is_off = FALSE
      AND tc.class_type = ?

    GROUP BY 
      t.train_id,
      t.train_name,
      t.train_number,
      s.schedule_id,
      s.departure_time,
      s.arrival_time,
      src.station_name,
      dest.station_name,
      tc.class_type
  `;

    return this.db.query(query, [
      dto.date,
      dto.from,
      dto.to,
      dayOfWeek,
      dto.class,
    ]);
  }

  async getSeats(scheduleId: number, date: string, classType: string) {
    const query = `
        SELECT 
          tc.coach_id,
          tc.coach_label,
          tc.class_type,
          s.seat_id,
          s.seat_number,
      CASE 
        WHEN b.booking_id IS NULL THEN 'AVAILABLE'
        ELSE 'BOOKED'
      END AS status

    FROM train_coaches tc
    JOIN seats s ON s.coach_id = tc.coach_id

    LEFT JOIN booking_seats bs ON bs.seat_id = s.seat_id
    LEFT JOIN bookings b ON b.booking_id = bs.booking_id
      AND b.schedule_id = ?
      AND b.journey_date = ?
      AND b.status = 'CONFIRMED'

    WHERE 
      tc.train_id = (
        SELECT train_id FROM schedules WHERE schedule_id = ?
      )
      AND tc.class_type = ?

    ORDER BY tc.coach_id, s.seat_number;

    `;
    const rows = await this.db.query<any[]>(query, [
      scheduleId,
      date,
      scheduleId,
      classType,
    ]);

    return this.groupSeats(rows);
  }
}
