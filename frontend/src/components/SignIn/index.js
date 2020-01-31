import React, { useState } from 'react';

import Button from '../Button';
import Toast from '../Toast';
import { getUser } from '../../services/benefits';

import css from './signin.module.css';

const SignIn = ({ onSignIn }) => {
  const [username, setUsername] = useState('');
  const [fetching, setFetching] = useState(false);
  const [toast, setToast] = useState(null);

  const onSubmit = newUsername => {
    setFetching(true);
    getUser(newUsername)
      .then(user => {
        setFetching(false);
        onSignIn(user);
      })
      .catch(() => {
        setFetching(false);
        setToast('Could not fetch User');
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
        <div className={css.footer}>
          <Button label="Sign In" type="submit" disabled={fetching} />
        </div>
      </form>
      {toast ? <Toast message={toast} onClose={() => setToast(null)} /> : null}
    </div>
  );
};

export default SignIn;
