import { Injectable, NotFoundException, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task } from './task.entity';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { User } from 'src/user/user.entity';
import { Board } from 'src/board/board.entity';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepo: Repository<Task>,
    
    @InjectRepository(Board)
    private readonly boardRepo: Repository<Board>,
  ) {}

  async create(dto: CreateTaskDto, user: User, boardId: number): Promise<Task> {
  try {
    const board = await this.boardRepo.findOne({ where: { id: boardId } });

    if (!board) {
      throw new NotFoundException('Board não encontrado');
    }

    const task = this.taskRepo.create({
      ...dto,
      user,
      board,
    });

    return await this.taskRepo.save(task);
  } catch (error) {
    throw new InternalServerErrorException('Erro ao criar tarefa');
  }
}


 async findAll(userId: number, boardId: number): Promise<Task[]> {
  return await this.taskRepo.find({
    where: { 
      user: { id: userId },
      board: { id: boardId },
    },
    order: { createdAt: 'DESC' },
    relations: ['board'], 
  });
}

  async update(id: number, dto: UpdateTaskDto): Promise<Task> {
    const task = await this.taskRepo.findOne({ where: { id } });
    if (!task) throw new NotFoundException('Tarefa não encontrada');

    Object.assign(task, dto);
    return await this.taskRepo.save(task);
  }

  async delete(id: number): Promise<{ message: string }> {
    const task = await this.taskRepo.findOne({ where: { id } });
    if (!task) throw new NotFoundException('Tarefa não encontrada');

    await this.taskRepo.remove(task);
    return { message: 'Tarefa deletada com sucesso' };
  }
}
