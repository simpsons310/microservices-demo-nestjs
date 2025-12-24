import { Controller, Get, Post, Body, Param, Headers } from '@nestjs/common';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';

@Controller('orders')
export class OrderController {
  constructor(private readonly orderService: OrderService) { }

  @Post()
  create(
    @Headers('x-user-id') userId: string,
    @Body() createOrderDto: CreateOrderDto,
  ) {
    if (!userId) {
      throw new Error('User ID is required');
    }
    return this.orderService.create(userId, createOrderDto);
  }

  @Get()
  findAll(@Headers('x-user-id') userId: string) {
    if (!userId) {
      throw new Error('User ID is required');
    }
    return this.orderService.findAll(userId);
  }

  @Get(':id')
  findOne(
    @Param('id') id: string,
    @Headers('x-user-id') userId: string,
  ) {
    if (!userId) {
      throw new Error('User ID is required');
    }
    return this.orderService.findOneByUser(id, userId);
  }
}
