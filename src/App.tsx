import { ReactElement } from "react";
import './App.css';

import { Board } from "./components/Board";


export const App = (): ReactElement => {
  return (
    <div className="App">
      <Board />
    </div>
  );
}
