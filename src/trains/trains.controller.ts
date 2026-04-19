import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { TrainsService } from './trains.service';

@ApiTags('Trains')
@Controller('trains')
export class TrainsController {
  constructor(private readonly trainsService: TrainsService) {}

  @Get()
  getAllTrains() {
    return this.trainsService.getAll();
  }
}
