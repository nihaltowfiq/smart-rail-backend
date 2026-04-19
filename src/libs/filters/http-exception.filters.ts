import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from '@nestjs/common';
import { Response } from 'express';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    const status = exception.getStatus();
    // const exceptionResponse = exception.getResponse();

    response.status(status).json({
      success: false,
      message: 'Something went wrong',
      // message:
      //   typeof exceptionResponse == 'string'
      //     ? exceptionResponse
      //     : typeof exceptionResponse == 'object'
      //       ? exceptionResponse?.message
      //       : 'Something went wrong',
      data: null,
      status,
    });
  }
}
