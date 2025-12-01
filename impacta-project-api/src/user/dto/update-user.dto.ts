import { IsEmail, IsOptional, MinLength } from "class-validator";


export class UpdateUserDto {
    @IsOptional()
    name?: string;

    @IsOptional()
    @IsEmail({}, {message: 'E-mail inválido'})
    email?: string;

    @IsOptional()
    @MinLength(6, {message: 'A senha deve ter no mínimo 6 caracteres'})
    password?: string;
}