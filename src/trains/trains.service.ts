import { DbService } from 'src/database/db.service';

export class TrainsService {
  constructor(private db: DbService) {}

  async getAll() {
    return this.db.query('SELECT * FROM trains');
  }
}
