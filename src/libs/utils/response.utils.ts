import { ApiResponse } from '../types/api-response.type';

export function successResponse<T>(
  data: T,
  message = 'Success',
  status = 200,
): ApiResponse<T> {
  return {
    success: true,
    message,
    data,
    status,
  };
}

export function errorResponse(
  message = 'Error',
  status = 400,
): ApiResponse<null> {
  return {
    success: false,
    message,
    data: null,
    status,
  };
}
