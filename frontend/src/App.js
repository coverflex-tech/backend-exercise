import React, { useState } from 'react';

import SignIn from './components/SignIn';
import Catalog from './components/Catalog';
import logoSVG from './assets/logo.svg';

import css from './app.module.css';

const App = () => {
  /**
   * Session/State management
   */
  const [user, setUser] = useState(null);
  const [balance, setBalance] = useState(0);

  const onSignIn = signedUser => {
    setUser(signedUser);
    setBalance(signedUser.balance || 0);
  };

  return (
    <div className={css.host}>
      <div className={css.content}>
        <div className={css.header}>
          <img src={logoSVG} className={css.logo} />
          {user && (
            <div className={css.user}>
              <div>
                <span role="img">👋</span> Hello, {user.user_id}
              </div>
              <div className={css.balance}>
                <span role="img">💰</span>
                {balance} FlexPoints
              </div>
            </div>
          )}
        </div>
        {/**
         * Assuming this application will grow and scale, how would you handle this type of complexity.
         */}
        {user ? (
          <Catalog user={user} onChange={setBalance} />
        ) : (
          <SignIn onSignIn={onSignIn} />
        )}
      </div>
    </div>
  );
};

export default App;
