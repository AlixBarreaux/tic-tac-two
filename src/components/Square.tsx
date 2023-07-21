import { ReactElement } from "react";

import { ISquareProps } from "../typescript/interfaces/square/SquareProps.interface";


export const Square = ({value, onSquareClick}: ISquareProps): ReactElement => {
  return (
    <button className="square" onClick={onSquareClick}>
      {value}
    </button>
  );
}