import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Task } from './task.entity';
import { TaskService } from './task.service';
import { TaskController } from './task.controller';
import { Board } from 'src/board/board.entity';

@Module({
imports: [
    TypeOrmModule.forFeature([Task, Board]), // ✅ adicionar Board aqui!
  ],  controllers: [TaskController],
  providers: [TaskService],
  exports: [TaskService],
})
export class TaskModule {}
