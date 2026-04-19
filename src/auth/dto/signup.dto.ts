import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, Matches, MinLength } from 'class-validator';

export class SignupDto {
  @ApiProperty({
    example: '01712345678',
    description: 'Bangladeshi phone number',
  })
  @IsNotEmpty()
  @Matches(/^01[3-9]\d{8}$/)
  phone: string;

  @ApiProperty({
    example: '123456',
    description: 'User password (min 6 chars)',
  })
  @IsNotEmpty()
  @MinLength(6)
  password: string;
}
