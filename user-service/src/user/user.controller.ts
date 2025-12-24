import { Controller, Get, Param } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Get(':id')
  async getUserById(@Param('id') id: string) {
    const user = await this.userService.findById(id);
    const { password, ...result } = user;
    return result;
  }

  @Get('me/:id')
  async getProfile(@Param('id') id: string) {
    const user = await this.userService.findById(id);
    const { password, ...result } = user;
    return result;
  }
}
