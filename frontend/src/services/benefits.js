import axios from 'axios';

const instance = axios.create({
  baseURL: ''
});

export const getUser = username => {
  return instance.get(`/api/users/${username}`).then(response => {
    const { data } = response;
    return {
      user_id: data.user.user_id,
      ...data.user.data
    };
  });
};

export const getProducts = () => {
  return instance.get(`/api/products`).then(response => {
    const { data } = response;
    return data.products;
  });
};

export const placeOrder = (order, username) => {
  return instance
    .post(`/api/orders`, {
      order: {
        items: order.map(item => item.id),
        user_id: username
      }
    })
    .then(response => {
      const { data } = response;
      return data;
    });
};
