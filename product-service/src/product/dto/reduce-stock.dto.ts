import { IsNumber, Min } from 'class-validator';

export class ReduceStockDto {
  @IsNumber()
  @Min(1)
  quantity: number;
}
