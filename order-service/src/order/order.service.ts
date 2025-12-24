import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order, OrderStatus } from './order.entity';
import { OrderItem } from './order-item.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { ProductClient } from '../clients/product.client';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order)
    private orderRepository: Repository<Order>,
    @InjectRepository(OrderItem)
    private orderItemRepository: Repository<OrderItem>,
    private productClient: ProductClient,
  ) { }

  async create(userId: string, createOrderDto: CreateOrderDto): Promise<Order> {
    let totalAmount = 0;
    const orderItems: OrderItem[] = [];

    // Validate products and calculate total
    for (const item of createOrderDto.items) {
      const product = await this.productClient.getProduct(item.productId);

      if (product.stock < item.quantity) {
        throw new BadRequestException(
          `Insufficient stock for product: ${product.name}. Available: ${product.stock}`,
        );
      }

      const orderItem = this.orderItemRepository.create({
        productId: item.productId,
        productName: product.name,
        quantity: item.quantity,
        price: product.price,
      });

      orderItems.push(orderItem);
      totalAmount += product.price * item.quantity;
    }

    // Create order
    const order = this.orderRepository.create({
      userId,
      totalAmount,
      status: OrderStatus.PENDING,
      items: orderItems,
    });

    const savedOrder = await this.orderRepository.save(order);

    // Reduce stock for each product
    try {
      for (const item of createOrderDto.items) {
        await this.productClient.reduceStock(item.productId, item.quantity);
      }

      // Update order status to confirmed
      savedOrder.status = OrderStatus.CONFIRMED;
      await this.orderRepository.save(savedOrder);
    } catch (error) {
      // If stock reduction fails, cancel the order
      savedOrder.status = OrderStatus.CANCELLED;
      await this.orderRepository.save(savedOrder);
      throw new BadRequestException('Failed to process order: ' + error.message);
    }

    return this.findOne(savedOrder.id);
  }

  async findAll(userId: string): Promise<Order[]> {
    return this.orderRepository.find({
      where: { userId },
      relations: ['items'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id },
      relations: ['items'],
    });

    if (!order) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }

    return order;
  }

  async findOneByUser(id: string, userId: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id, userId },
      relations: ['items'],
    });

    if (!order) {
      throw new NotFoundException(`Order with ID ${id} not found`);
    }

    return order;
  }
}
