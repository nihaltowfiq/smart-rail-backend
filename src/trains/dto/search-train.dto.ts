import { IsDateString, IsString } from 'class-validator';

export class SearchTrainDto {
  @IsString()
  from: string = '';

  @IsString()
  to: string = '';

  @IsDateString()
  date: string = '';

  @IsString()
  class: string = '';
}
