import { MouseEventHandler } from "react";


export interface ISquareProps {
  value: string;
  onSquareClick: MouseEventHandler<HTMLButtonElement>;
}