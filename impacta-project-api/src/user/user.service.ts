import { Injectable, BadRequestException, InternalServerErrorException, UnauthorizedException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import * as bcrypt from 'bcrypt';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private userRepo: Repository<User>,
  ) {}

  async findAll(): Promise<User[]> {
    try {
      return await this.userRepo.find();
    } catch (error) {
      throw new InternalServerErrorException('Erro ao buscar usuários');
    }
  }

  async create(dto: CreateUserDto): Promise<User> {
    try {
      const exists = await this.userRepo.findOne({ where: { email: dto.email } });
      if (exists) {
        throw new BadRequestException('E-mail já está em uso');
      }

      const hashedPassword = await bcrypt.hash(dto.password, 10);
      const user = this.userRepo.create({ ...dto, password: hashedPassword });

      return await this.userRepo.save(user);
    } catch (error) {
      if (error instanceof BadRequestException) {
        throw error;
      }
      throw new InternalServerErrorException('Erro ao criar usuário');
    }
  }

  async login(dto: LoginUserDto): Promise<{ message: string; user: Partial<User> }> {
    try {
      const user = await this.userRepo.findOne({ where: { email: dto.email } });
      if (!user) {
        throw new UnauthorizedException('Credenciais inválidas');
      }

      const isPasswordValid = await bcrypt.compare(dto.password, user.password);
      if (!isPasswordValid) {
        throw new UnauthorizedException('Credenciais inválidas');
      }

      const { password, ...safeUser } = user;
      return { message: 'Login realizado com sucesso', user: safeUser };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new InternalServerErrorException('Erro ao realizar login');
    }
  }

  async update(id: number, dto: UpdateUserDto): Promise<User> {
    try{
      const user = await this.userRepo.findOne({ where: {id }});
      if(!user){
        throw new NotFoundException('Usuario não encontrado')
      }

      if(dto.email && dto.email !== user.email){
        const exists = await this.userRepo.findOne({ where: { email: dto.email }})
        if(exists){
          throw new BadRequestException('E-mail já está em uso')
        }
      }

      if(dto.password){
        dto.password = await bcrypt.hash(dto.password, 10)
      }

      Object.assign(user, dto)

      return await this.userRepo.save(user)
    } catch (error){
      if(error instanceof NotFoundException || error instanceof BadRequestException){
        throw error
      }
      throw new InternalServerErrorException('Erro ao atualizar usuário')
    }
  }

  async delete(id: number): Promise<void>{
    try{
      const user = await this.userRepo.findOne({ where: {id}})
      if(!user){
        throw new NotFoundException('Usuário não encontrado')
      }

      await this.userRepo.remove(user)
    } catch(error){
      if(error instanceof NotFoundException){
        throw error;
      }
      throw new InternalServerErrorException('Erro ao deletar usuário')
    }
  }
}
