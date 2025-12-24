import {
  Controller,
  All,
  Req,
  Res,
  UseGuards,
  HttpException,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ProxyService } from './proxy.service';
import { JwtAuthGuard } from '../auth/jwt.guard';

@Controller('api')
export class ProxyController {
  constructor(private readonly proxyService: ProxyService) { }

  // Auth routes (no JWT required)
  @All('auth/*')
  async authProxy(@Req() req: Request, @Res() res: Response) {
    try {
      const result = await this.proxyService.forwardToUserService(req);
      return res.status(result.status).json(result.data);
    } catch (error) {
      throw new HttpException(
        error.response?.data || error.message,
        error.response?.status || 500,
      );
    }
  }

  // User routes (JWT required)
  @All('users/*')
  @UseGuards(JwtAuthGuard)
  async userProxy(@Req() req: Request, @Res() res: Response) {
    try {
      const result = await this.proxyService.forwardToUserService(req);
      return res.status(result.status).json(result.data);
    } catch (error) {
      throw new HttpException(
        error.response?.data || error.message,
        error.response?.status || 500,
      );
    }
  }

  // Product routes (public for GET, JWT for POST/PUT/DELETE)
  @All('products*')
  async productProxy(@Req() req: Request, @Res() res: Response) {
    // Check if it's a mutation operation
    const requiresAuth = ['POST', 'PUT', 'DELETE'].includes(req.method);

    if (requiresAuth) {
      // Manually verify JWT for mutation operations
      const jwtGuard = new JwtAuthGuard(this.proxyService['jwtService']);
      const canActivate = await jwtGuard.canActivate({
        switchToHttp: () => ({
          getRequest: () => req,
        }),
      } as any);

      if (!canActivate) {
        throw new HttpException('Unauthorized', 401);
      }
    }

    try {
      const result = await this.proxyService.forwardToProductService(req);
      return res.status(result.status).json(result.data);
    } catch (error) {
      throw new HttpException(
        error.response?.data || error.message,
        error.response?.status || 500,
      );
    }
  }

  // Order routes (JWT required)
  @All('orders*')
  @UseGuards(JwtAuthGuard)
  async orderProxy(@Req() req: Request, @Res() res: Response) {
    try {
      // Add user ID to headers for order service
      const userId = req['user']?.sub;
      const result = await this.proxyService.forwardToOrderService(req, userId);
      return res.status(result.status).json(result.data);
    } catch (error) {
      throw new HttpException(
        error.response?.data || error.message,
        error.response?.status || 500,
      );
    }
  }
}
