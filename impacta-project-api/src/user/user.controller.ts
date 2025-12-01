import { Controller, Get, Post, Body, Put, Delete, Param } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  async findAll() {
    return await this.userService.findAll();
  }

  @Post('/register')
  async create(@Body() dto: CreateUserDto) {
    return await this.userService.create(dto);
  }

  @Post('/login')
  async login(@Body() dto: LoginUserDto) {
    return await this.userService.login(dto);
  }

  @Put(':id')
  async update(@Param('id') id: number, @Body() dto: UpdateUserDto) {
    return await this.userService.update(+id, dto);
  }

  @Delete(':id')
  async delete(@Param('id') id: number) {
    return await this.userService.delete(+id);
  }
}
