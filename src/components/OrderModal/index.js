import React, { useEffect, useMemo, useState } from 'react';

import Button from '../Button';
import { placeOrder } from '../../services/benefits';

import css from './order-modal.module.css';
import Toast from '../Toast';

const OrderModal = ({ order, user, onClose, onConfirm }) => {
  const [fetching, setFetching] = useState(false);
  const [toast, setToast] = useState(null);

  useEffect(() => {
    document.addEventListener('click', onClose);

    return () => {
      document.removeEventListener('click', onClose);
    };
  }, [onClose]);

  const confirmOrder = () => {
    setFetching(true);
    placeOrder(order, user.user_id)
      .then(() => {
        setFetching(false);
        onConfirm(order.map(item => item.id));
      })
      .catch(err => {
        setToast('Could not place order');
        setFetching(false);
      });
  };

  const totalPoints = useMemo(
    () => order.reduce((acc, val) => acc + val.price, 0),
    [order]
  );

  return (
    <div className={css.host}>
      <div
        className={css.wrapper}
        onClick={evt => {
          evt.nativeEvent.stopImmediatePropagation();
        }}
      >
        <h2 className={css.headline}>
          Everything ready for you to enjoy your new benefits:
        </h2>
        <div className={css.items}>
          {order.map(item => (
            <div className={css.item} key={item.id}>
              <span>{item.name}</span>
              <span>{item.price} FlexPoints</span>
            </div>
          ))}
        </div>
        <div className={css.footer}>
          <div className={css.total}>
            <div>Total Points: {totalPoints}</div>
            <div>Total Balance: {(user.balance || 0) - totalPoints}</div>
          </div>
          <Button
            type="button"
            label="Confirm"
            onClick={confirmOrder}
            disabled={fetching}
          />
        </div>
      </div>
      {toast ? <Toast message={toast} onClose={() => setToast(null)} /> : null}
    </div>
  );
};

export default OrderModal;
