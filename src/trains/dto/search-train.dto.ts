import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsEnum, IsString } from 'class-validator';
import { TravelClass } from 'src/libs/types/trains';

export class SearchTrainDto {
  @ApiProperty({
    example: 'Dhaka',
  })
  @IsString()
  from: string = '';

  @ApiProperty({
    example: 'Rajshahi',
  })
  @IsString()
  to: string = '';

  @ApiProperty({
    example: '12-12-2012',
  })
  @IsDateString()
  date: string = '';

  @ApiProperty({
    example: 'AC',
  })
  @IsString()
  class: string = '';
}

export class GetSeatsQueryDto {
  @ApiProperty({
    example: '12-12-2026',
  })
  @IsDateString()
  date: string;

  @ApiProperty({
    example: 'AC',
  })
  @IsEnum(TravelClass)
  class: TravelClass;
}
