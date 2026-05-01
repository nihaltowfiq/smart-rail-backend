import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';

export enum PaymentMethod {
  BKASH = 'BKASH',
  NAGAD = 'NAGAD',
}

export class MakePaymentDto {
  @ApiProperty({
    example: 'BKASH',
    enum: PaymentMethod,
  })
  @IsEnum(PaymentMethod)
  payment_method!: PaymentMethod;
}
