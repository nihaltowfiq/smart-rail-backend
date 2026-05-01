/* eslint-disable @typescript-eslint/no-unsafe-return */
import {
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/auth/auth.guard';
import { AdminService } from './admin.service';
import { GetTrainsFilterDto } from './dto/get-trains.dto';

@ApiTags('Admin')
@UseGuards(AuthGuard)
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('/trains')
  @ApiOperation({
    summary: 'Get list of trains with income and dynamic filters',
  })
  async getTrains(@Query() filter: GetTrainsFilterDto) {
    return this.adminService.getTrainsWithIncome(filter);
  }

  @Get('/trains/:trainId')
  @ApiOperation({ summary: 'Get detailed statistics for a specific train' })
  async getTrainStats(@Param('trainId', ParseIntPipe) trainId: number) {
    return this.adminService.getTrainDetailedStats(trainId);
  }

  @Get('/income-by-payment-method')
  @ApiOperation({
    summary:
      'Get income breakdown by payment method with optional train and date filters',
  })
  async getIncomeByPaymentMethod(
    @Query('trainId') trainId?: number,
    @Query('incomeFilter')
    incomeFilter: 'ALL_TIME' | 'YEAR' | 'MONTH' = 'ALL_TIME',
    @Query('year') year?: number,
    @Query('month') month?: number,
  ) {
    return this.adminService.getIncomeByPaymentMethod(
      trainId,
      incomeFilter,
      year,
      month,
    );
  }
}
