import { PartialType } from '@nestjs/mapped-types';
import { CreateTaskDto } from './create-task.dto';
import { IsIn, IsOptional } from 'class-validator';

export class UpdateTaskDto extends PartialType(CreateTaskDto) {
  @IsOptional()
  @IsIn(['todo', 'in_progress', 'done'], { message: 'Status inválido' })
  status?: 'todo' | 'in_progress' | 'done';
}
