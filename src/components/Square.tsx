import { ReactElement } from "react";


interface ISquareProps {
  value: string;
  onSquareClick: any;
}

export const Square = ({value, onSquareClick}: ISquareProps): ReactElement => {
  return(
    <button
      className="square"
      onClick={onSquareClick}
    >
      {value}
    </button>
  );
}