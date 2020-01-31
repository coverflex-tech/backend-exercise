import React, { useState } from 'react';

import SignIn from './components/SignIn';
import Catalog from './components/Catalog';
import logoSVG from './assets/logo.svg';

import css from './app.module.css';

const App = () => {
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
          <img src={logoSVG} className={css.logo} alt="Coverflex Logo" />
          {user && (
            <div className={css.user}>
              <div>
                <span role="img" aria-label="Hello">👋</span> Hello, {user.user_id}
              </div>
              <div className={css.balance}>
                <span role="img" aria-label="Balance">💰</span>
                {balance} FlexPoints
              </div>
            </div>
          )}
        </div>
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
