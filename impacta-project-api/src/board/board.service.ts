import {
  Injectable,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Board } from './board.entity';
import { User } from 'src/user/user.entity';
import { CreateBoardDto } from './dto/create-board.dto';
import { UpdateBoardDto } from './dto/update-board.dto';

@Injectable()
export class BoardService {
  constructor(
    @InjectRepository(Board)
    private readonly boardRepo: Repository<Board>,
  ) {}

  async create(dto: CreateBoardDto, users: User[]): Promise<Board> {
    try {
      const board = this.boardRepo.create({
        name: dto.name,
        users,
      });
      return await this.boardRepo.save(board);
    } catch (error) {
      console.error(error);
      throw new InternalServerErrorException('Erro ao criar board');
    }
  }

  async findAll(userId: number): Promise<Board[]> {
  return await this.boardRepo
    .createQueryBuilder('board')
    .leftJoinAndSelect('board.users', 'user')
    .leftJoinAndSelect('board.tasks', 'task')
    .where('user.id = :userId', { userId })
    .orderBy('board.createdAt', 'DESC')
    .getMany();
}


  async findById(id: number): Promise<Board> {
    const board = await this.boardRepo.findOne({
      where: { id },
      relations: ['users', 'tasks'],
    });

    if (!board) throw new NotFoundException('Board não encontrado');
    return board;
  }

  async update(id: number, dto: UpdateBoardDto): Promise<Board> {
    const board = await this.boardRepo.findOne({ where: { id } });
    if (!board) throw new NotFoundException('Board não encontrado');

    Object.assign(board, dto);
    return await this.boardRepo.save(board);
  }

  async delete(id: number): Promise<{ message: string }> {
    const board = await this.boardRepo.findOne({ where: { id } });
    if (!board) throw new NotFoundException('Board não encontrado');

    await this.boardRepo.remove(board);
    return { message: 'Board deletado com sucesso' };
  }
}
