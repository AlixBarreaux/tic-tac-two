import { MouseEventHandler, ReactElement } from "react";


interface ISquareProps {
  value: string;
  onSquareClick: MouseEventHandler<HTMLButtonElement>;
}


export const Square = ({value, onSquareClick}: ISquareProps): ReactElement => {
  return (
    <button className="square" onClick={onSquareClick}>
      {value}
    </button>
  );
}