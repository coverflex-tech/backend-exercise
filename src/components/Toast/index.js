import React, { useEffect } from 'react';
import ReactDOM from 'react-dom';

import css from './toast.module.css';

const Toast = ({ message, onClose }) => {
  useEffect(() => {
    const timeout = setTimeout(onClose, 3000);
    return () => clearTimeout(timeout);
  });

  return ReactDOM.createPortal(
    <div className={css.host}>{message}</div>,
    document.getElementById('toast')
  );
};

export default Toast;
