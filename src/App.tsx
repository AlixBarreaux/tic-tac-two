import { ReactElement } from "react";
import './App.css';

//#region Components imports
import { Game } from "./components/Game";
//#endregion Components imports


export const App = (): ReactElement => {
  return (
    <div className="App">
      <Game />
    </div>
  );
}
