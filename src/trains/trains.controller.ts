import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { SearchTrainDto } from './dto/search-train.dto';
import { TrainsService } from './trains.service';

@ApiTags('Trains')
@UseGuards(AuthGuard)
@Controller('trains')
export class TrainsController {
  constructor(private readonly trainsService: TrainsService) {}

  @Post('search')
  search(@Body() dto: SearchTrainDto) {
    return this.trainsService.search(dto);
  }
}
