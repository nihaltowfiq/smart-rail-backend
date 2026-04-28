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
import { GetSeatsQueryDto, SearchTrainDto } from './dto/search-train.dto';
import { TrainsService } from './trains.service';

@ApiTags('Trains')
@UseGuards(AuthGuard)
@Controller('trains')
export class TrainsController {
  constructor(private readonly trainsService: TrainsService) {}

  @Post('search')
  @ApiOperation({ summary: 'Search Trains' })
  search(@Body() dto: SearchTrainDto) {
    return this.trainsService.search(dto);
  }

  @Get(':scheduleId/seats')
  @ApiOperation({ summary: 'Get seats' })
  getSeats(
    @Param('scheduleId', ParseIntPipe) scheduleId: number,
    @Query() query: GetSeatsQueryDto,
  ) {
    return this.trainsService.getSeats(scheduleId, query.date, query.class);
  }
}
