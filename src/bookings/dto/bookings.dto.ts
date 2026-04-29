import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsDateString,
  IsEnum,
  IsInt,
  IsNumber,
} from 'class-validator';

export enum ClassType {
  NON_AC = 'NON_AC',
  AC = 'AC',
}

export class CreateBookingDto {
  @ApiProperty({
    example: 123456,
  })
  @IsInt()
  scheduleId!: number;

  @ApiProperty({
    example: '12/12/2026',
  })
  @IsDateString()
  journeyDate!: string;

  @ApiProperty({
    example: 'AC',
  })
  @IsEnum(ClassType)
  classType!: ClassType;

  @ApiProperty({
    example: [1, 2, 3],
  })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(5)
  seatIds!: number[];

  @ApiProperty({
    example: 900,
  })
  @IsNumber()
  totalAmount!: number;
}
