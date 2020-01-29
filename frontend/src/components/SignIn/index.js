import React, { useState } from 'react';

import Button from '../Button';
import { getUser } from '../../services/benefits';

import css from './signin.module.css';

const SignIn = ({ onSignIn }) => {
  const [username, setUsername] = useState('');
  const [fetching, setFetching] = useState(false);

  /**
   * How do you usually handle authentication?
   */
  const onSubmit = newUsername => {
    setFetching(true);
    getUser(newUsername).then(user => {
      setFetching(false);
      onSignIn(user);
    });
  };

  return (
    <div className={css.host}>
      <h1 className={css.title}>
        Welcome to <br />
        our benefits platform
      </h1>
      <h2 className={css.headline}> Start by telling us your name</h2>
      <form
        className={css.form}
        onSubmit={evt => {
          evt.preventDefault();
          onSubmit(username);
        }}
      >
        <input
          type="text"
          className={css.input}
          placeholder="Please insert your name"
          value={username}
          onChange={evt => setUsername(evt.target.value)}
        />
        {/**
         * Form validation
         */}
        <div className={css.footer}>
          <Button label="Sign In" type="submit" disabled={fetching} />
        </div>
      </form>
    </div>
  );
};

export default SignIn;
