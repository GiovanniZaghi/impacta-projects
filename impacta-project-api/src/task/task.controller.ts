import { Controller, Post, Get, Put, Delete, Body, Param } from '@nestjs/common';
import { TaskService } from './task.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { User } from 'src/user/user.entity';

@Controller('tasks')
export class TaskController {
  constructor(private readonly taskService: TaskService) {}

  @Post(':userId/:boardId')
async create(
  @Param('userId') userId: number,
  @Param('boardId') boardId: number,
  @Body() dto: CreateTaskDto,
) {
  const user = { id: userId } as User;
  return await this.taskService.create(dto, user, boardId);
}


  @Get(':userId/:boardId')
async getTasksByBoard(
  @Param('boardId') boardId: number,
  @Param('userId') userId: number,
) {
  return this.taskService.findAll(userId, boardId);
}



  @Put(':id')
  async update(@Param('id') id: number, @Body() dto: UpdateTaskDto) {
    return await this.taskService.update(+id, dto);
  }


  @Delete(':id')
  async delete(@Param('id') id: number) {
    return await this.taskService.delete(+id);
  }
}
