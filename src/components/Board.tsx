import { ReactElement, useState } from "react";

//#region Components imports
import { Square } from "./Square";
//#endregion Components imports

export const Board = (): ReactElement => {

  const [xIsNext, setXIsNext] = useState<boolean>(true);
  const [squares, setSquares] = useState<string[]>(
    ["", "", "", "", "", "", "", "", ""]
  );

  const handleClick = (i: number): void => {
    // If pawn present or game won, stop here
    if (squares[i] !== "" || calculateWinner(squares) !== "" ) return

    const nextSquares = squares.slice();

    if (xIsNext) {
      nextSquares[i] = "X";
    }
    else {
      nextSquares[i] = "O";
    }

    setSquares(nextSquares);
    setXIsNext(!xIsNext);
  }

  const winner: any = calculateWinner(squares);

  let status: string = "";
  
  if (winner) {
    status = "Winner: " + winner;
  }
  else {
    status = "Next player: " + (xIsNext ? "X" : "O");
  }

  return(
    <>
      <h2 className="status">{status}</h2>

      <div className="board-row">
        <Square value={squares[0]} onSquareClick={() => handleClick(0)} />
        <Square value={squares[1]} onSquareClick={() => handleClick(1)} />
        <Square value={squares[2]} onSquareClick={() => handleClick(2)} />
      </div>
      <div className="board-row">
        <Square value={squares[3]} onSquareClick={() => handleClick(3)} />
        <Square value={squares[4]} onSquareClick={() => handleClick(4)} />
        <Square value={squares[5]} onSquareClick={() => handleClick(5)} />
      </div>
      <div className="board-row">
        <Square value={squares[6]} onSquareClick={() => handleClick(6)} />
        <Square value={squares[7]} onSquareClick={() => handleClick(7)} />
        <Square value={squares[8]} onSquareClick={() => handleClick(8)} />
      </div>
    </>
  );
}


function calculateWinner(squares: string[]): string {
  const lines: number[][] = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  for (let i: number = 0; (i < lines.length); i++) {
    // Squares values of a line
    const [squareValue1, squareValue2, squareValue3]: number[] = lines[i];
    
    // Check if the current line is full of "X"s or "O"s
    if (squares[squareValue1] !== "" && 
      squares[squareValue1] === squares[squareValue2] 
      && squares[squareValue1] === squares[squareValue3]) 
      {
        return squares[squareValue1];
      }
    }
  return "";
}