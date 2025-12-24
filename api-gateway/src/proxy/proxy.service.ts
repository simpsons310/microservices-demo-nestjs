import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { firstValueFrom } from 'rxjs';
import { Request } from 'express';

@Injectable()
export class ProxyService {
  private readonly userServiceUrl: string;
  private readonly productServiceUrl: string;
  private readonly orderServiceUrl: string;

  constructor(
    private readonly httpService: HttpService,
    private readonly jwtService: JwtService,
  ) {
    this.userServiceUrl = process.env.USER_SERVICE_URL || 'http://localhost:3001';
    this.productServiceUrl = process.env.PRODUCT_SERVICE_URL || 'http://localhost:3002';
    this.orderServiceUrl = process.env.ORDER_SERVICE_URL || 'http://localhost:3003';
  }

  async forwardToUserService(req: Request) {
    const path = req.url.replace('/api', '');
    const url = `${this.userServiceUrl}${path}`;

    return this.forwardRequest(url, req.method, req.body, req.query);
  }

  async forwardToProductService(req: Request) {
    const path = req.url.replace('/api', '');
    const url = `${this.productServiceUrl}${path}`;

    return this.forwardRequest(url, req.method, req.body, req.query);
  }

  async forwardToOrderService(req: Request, userId?: string) {
    const path = req.url.replace('/api', '');
    const url = `${this.orderServiceUrl}${path}`;

    const headers = userId ? { 'x-user-id': userId } : {};
    return this.forwardRequest(url, req.method, req.body, req.query, headers);
  }

  private async forwardRequest(
    url: string,
    method: string,
    body?: any,
    query?: any,
    headers?: any,
  ) {
    const config = {
      params: query,
      headers,
    };

    let response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await firstValueFrom(this.httpService.get(url, config));
        break;
      case 'POST':
        response = await firstValueFrom(this.httpService.post(url, body, config));
        break;
      case 'PUT':
        response = await firstValueFrom(this.httpService.put(url, body, config));
        break;
      case 'PATCH':
        response = await firstValueFrom(this.httpService.patch(url, body, config));
        break;
      case 'DELETE':
        response = await firstValueFrom(this.httpService.delete(url, config));
        break;
      default:
        throw new Error(`Unsupported HTTP method: ${method}`);
    }

    return response;
  }
}
