export class PaginationDto {
  page?: number = 1;
  limit?: number = 10;
}

export class GetTrainsFilterDto extends PaginationDto {
  trainName?: string;
  trainNumber?: string;
  sortBy?: 'name' | 'number' | 'income' | 'bookings' = 'name';
  sortOrder?: 'ASC' | 'DESC' = 'ASC';
  incomeFilter?: 'ALL_TIME' | 'YEAR' | 'MONTH' = 'ALL_TIME';
  year?: number;
  month?: number; // 1-12
}

export interface TrainIncomeResponse {
  trainId: number;
  trainName: string;
  trainNumber: string;
  totalIncome: number;
  totalBookings: number;
  successfulPayments: number;
  totalPassengers: number;
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
}

export interface TrainListResponse {
  trains: Array<{
    trainId: number;
    trainName: string;
    trainNumber: string;
    totalIncome: number;
    totalBookings: number;
    successfulPayments: number;
    totalPassengers: number;
  }>;
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
}
