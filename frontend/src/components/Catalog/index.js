import React, { useEffect, useState } from 'react';

import { getProducts } from '../../services/benefits';
import Button from '../Button';
import OrderModal from '../OrderModal';

import css from './catalog.module.css';

/**
 * Client-side validation
 * Server-side error handling.
 */
const Catalog = ({ user, onChange }) => {
  const [catalog, setCatalog] = useState([]);
  const [selected, setSelected] = useState([]);
  const [bought, setBought] = useState(user.product_ids || []);
  const [order, setOrder] = useState([]);
  const [balance, setBalance] = useState(user.balance || 0);
  const [showModal, setShowModal] = useState(false);

  const onToggle = id => {
    const selectedIdx = selected.indexOf(id);
    const newSelected = selected.splice(0);
    const product = catalog.filter(item => item.id === id)[0];

    if (!product) {
      return;
    }

    let newBalance = balance;
    if (selectedIdx !== -1) {
      newSelected.splice(selectedIdx, 1);
      newBalance += product.price;
    } else {
      newSelected.push(id);
      newBalance -= product.price;
    }

    setSelected(newSelected);
    setBalance(newBalance);
    onChange(newBalance);
  };

  const placeOrder = () => {
    const orderProducts = catalog.filter(
      item =>
        selected.indexOf(item.id) !== -1 &&
        user.product_ids.indexOf(item.id) === -1
    );

    setOrder(orderProducts);
    setShowModal(true);
  };

  const onConfirmOrder = productIds => {
    setBought(bought.concat(productIds));
    setSelected([]);
    setShowModal(false);
  };

  useEffect(() => {
    getProducts().then(products => {
      setCatalog(products);
    });
  }, []);

  return (
    <div className={css.host}>
      <div className={css.grid}>
        {catalog.map(item => (
          <div
            className={`${css.item} ${
              selected.indexOf(item.id) !== -1 ? css.selected : ''
            } ${bought.indexOf(item.id) !== -1 ? css.bought : ''}`}
            key={item.id}
            onClick={() => onToggle(item.id)}
          >
            <div className={css.itemName}>{item.name}</div>
            <div className={css.itemPrice}>{item.price} FlexPoints</div>
          </div>
        ))}
      </div>
      <div className={css.cart}>
        <Button
          type="button"
          label="Place Order"
          onClick={placeOrder}
          disabled={balance < 0 || selected.length === 0}
        />
      </div>
      {showModal && (
        <OrderModal
          user={user}
          order={order}
          onClose={() => setShowModal(false)}
          onConfirm={onConfirmOrder}
        />
      )}
    </div>
  );
};

export default Catalog;
