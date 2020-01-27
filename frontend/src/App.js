import React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import Home from './scenes/Home'
import Submission from './scenes/Submission';
import Report from './scenes/Report'

import css from './app.module.css'

const App = () => {
  return (
    <BrowserRouter>
      <div className={css.wrapper}>
        <h1 className={css.title}>Welcome to Mordor Coin Exchange</h1>
        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route exact path="/report">
            <Report />
          </Route>
          <Route path="/:id">
            <Submission />
          </Route>
        </Switch>
      </div>
    </BrowserRouter>
  );
}

export default App;
