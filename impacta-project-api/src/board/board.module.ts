import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Board } from './board.entity';
import { BoardService } from './board.service';
import { BoardController } from './board.controller';
import { User } from 'src/user/user.entity';
import { Task } from 'src/task/task.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Board, User, Task])],
  controllers: [BoardController],
  providers: [BoardService],
  exports: [BoardService],
})
export class BoardModule {}
