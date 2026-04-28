import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsDateString,
  IsEnum,
  IsInt,
} from 'class-validator';

export enum ClassType {
  NON_AC = 'NON_AC',
  AC = 'AC',
}

export class CreateBookingDto {
  @IsInt()
  scheduleId!: number;

  @IsDateString()
  journeyDate!: string;

  @IsEnum(ClassType)
  classType!: ClassType;

  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(5)
  seatIds!: number[];
}
