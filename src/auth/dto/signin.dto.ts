import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';

export class SigninDto {
  @ApiProperty({
    example: '01712345678',
  })
  @IsNotEmpty()
  phone!: string;

  @ApiProperty({
    example: '123456',
  })
  @IsNotEmpty()
  password!: string;
}
