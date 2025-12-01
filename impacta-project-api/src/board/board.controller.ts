import {
  Controller,
  Post,
  Get,
  Param,
  Body,
  Patch,
  Delete,
  ParseIntPipe,
} from '@nestjs/common';
import { BoardService } from './board.service';
import { User } from 'src/user/user.entity'; 
import { CreateBoardDto } from './dto/create-board.dto';
import { UpdateBoardDto } from './dto/update-board.dto';
import { Board } from './board.entity';

@Controller('boards')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}

   @Post()
  async create(@Body() dto: CreateBoardDto): Promise<Board> {
    const user = { id: dto.userId } as User;
    return await this.boardService.create(dto, [user]);
  }

  @Get(':userId')
  async findAll(@Param('userId') userId: number): Promise<Board[]> {
    return await this.boardService.findAll(userId);
  }

  @Get(':id')
  async findById(@Param('id', ParseIntPipe) id: number): Promise<Board> {
    return await this.boardService.findById(id);
  }

  @Patch(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateBoardDto,
  ): Promise<Board> {
    return await this.boardService.update(id, dto);
  }

  @Delete(':id')
  async delete(@Param('id', ParseIntPipe) id: number) {
    return await this.boardService.delete(id);
  }
}
