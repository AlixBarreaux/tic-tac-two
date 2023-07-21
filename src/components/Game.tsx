import { ReactElement, useState } from "react";

import { Board } from "./Board";


export const Game = (): ReactElement => {
  const [history, setHistory] = useState<string[][]>(
    [ ["", "", "", "", "", "", "", "", ""] ]
    );
  const [currentMove, setCurrentMove] = useState<number>(0);
  const xIsNext: boolean = currentMove % 2 === 0;

  const currentSquares: string[] = history[currentMove];


  const handlePlay = (nextSquares: string[]): void => {
    const nextHistory: string[][] = [...history.slice(0, currentMove + 1), nextSquares];

    setHistory(nextHistory);
    setCurrentMove(nextHistory.length - 1);
  }


  function jumpTo(nextMove: number): void {
    setCurrentMove(nextMove);
  }


  const moves: ReactElement[] = history.map(
    (_currentSquares: string[], move: number) => {
      let description: string = "";

      if (move > 0) {
        description = `Go to move #${move}`;
      }
      else {
        description = "Go to game start";
      }
      return (
        <li key={move}>
          <button onClick={ () => jumpTo(move) }>{description}</button>
        </li>
      );
    }
  );


  return(
    <div className="game">
      <div className="game-board">
        <Board xIsNext={xIsNext} squares={currentSquares} onPlay={handlePlay} />
      </div>
      <div className="game-info">
        <ol>{moves}</ol>
      </div>
    </div>
  );
}