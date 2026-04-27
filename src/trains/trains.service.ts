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

  async search(dto: SearchTrainDto) {
    const dayOfWeek = getDayOfWeek(dto.date);

    const query = `
    SELECT 
      t.train_id,
      t.train_name,
      t.train_number,
      s.departure_time,
      s.arrival_time,
      src.station_name AS from_station,
      dest.station_name AS to_station
    FROM schedules s
    JOIN trains t ON t.train_id = s.train_id
    JOIN routes r ON r.route_id = s.route_id
    JOIN stations src ON src.station_id = r.source_station_id
    JOIN stations dest ON dest.station_id = r.destination_station_id
    JOIN train_coaches tc ON tc.train_id = t.train_id
    JOIN train_running_days trd ON trd.train_id = t.train_id
    WHERE 
      src.city = ?
      AND dest.city = ?
      AND tc.class_type = ?
      AND trd.day_of_week = ?
      AND trd.is_off = FALSE
    GROUP BY t.train_id, s.schedule_id
  `;

    return this.db.query(query, [dto.from, dto.to, dto.class, dayOfWeek]);
  }
}
