import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

export class CreateTaskDto {
  @IsNotEmpty({ message: 'O título é obrigatório' })
  title: string;

  @IsOptional()
  description?: string;

  @IsNumber()
  @IsNotEmpty({ message: 'O boardId é obrigatório' })
  boardId: number;
}
