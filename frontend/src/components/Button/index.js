import React from 'react';

import css from './button.module.css';

const Button = ({ label, type, disabled, onClick }) => {
  return (
    <button
      type={type}
      className={css.host}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
};

export default Button;
