import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany  } from 'typeorm';
import { Task } from 'src/task/task.entity';
import { Board } from 'src/board/board.entity';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column()
  birthday: string;

  @OneToMany(() => Task, (task) => task.user)
  tasks: Task[];

  @ManyToMany(() => Board, (board) => board.users)
  boards: Board[];
}
