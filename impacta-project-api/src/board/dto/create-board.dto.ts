import { IsNotEmpty, IsString, IsNumber } from 'class-validator';

export class CreateBoardDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNumber()
  @IsNotEmpty()
  userId: number; 
}
