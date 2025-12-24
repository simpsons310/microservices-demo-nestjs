import { Injectable, BadRequestException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class ProductClient {
  private readonly baseUrl: string;

  constructor(private readonly httpService: HttpService) {
    this.baseUrl = process.env.PRODUCT_SERVICE_URL || 'http://localhost:3002';
  }

  async getProduct(productId: string) {
    try {
      const response = await firstValueFrom(
        this.httpService.get(`${this.baseUrl}/products/${productId}`),
      );
      return response.data;
    } catch (error) {
      throw new BadRequestException(`Product not found: ${productId}`);
    }
  }

  async reduceStock(productId: string, quantity: number) {
    try {
      const response = await firstValueFrom(
        this.httpService.post(`${this.baseUrl}/products/${productId}/reduce-stock`, {
          quantity,
        }),
      );
      return response.data;
    } catch (error) {
      throw new BadRequestException(
        error.response?.data?.message || `Failed to reduce stock for product: ${productId}`,
      );
    }
  }
}
