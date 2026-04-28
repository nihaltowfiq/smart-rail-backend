export interface Train {
  id: number;
  name: string;
  from: string;
  to: string;
  departureTime: string;
  arrivalTime: string;
}

export enum TravelClass {
  NON_AC = 'NON_AC',
  AC = 'AC',
}
