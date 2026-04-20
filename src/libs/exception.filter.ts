/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from '@nestjs/common';
import { Response } from 'express';

import { HttpStatus } from '@nestjs/common';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const errorResponse: any =
      exception instanceof HttpException
        ? exception.getResponse()
        : 'Internal server error';

    const errorMessages = Array.isArray(errorResponse.message)
      ? errorResponse.message
      : [errorResponse.message || errorResponse];

    response.status(status).json({
      success: false,
      data: null,
      message: errorResponse.message,
      error: errorMessages,
      status,
    });
  }
}
