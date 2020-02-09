import axios from 'axios';

const instance = axios.create({
  baseURL: process.env.REACT_APP_API_BASE_URL
});

export const getUser = username => {  
  return instance.get(`/users/${username}`).then(response => {
    const { data } = response;
    return {
      user_id: data.user.user_id,
      ...data.user.data
    };
  });
};

export const getProducts = () => {
  return instance.get(`/products`).then(response => {
    const { data } = response;
    return data.products;
  });
};

export const placeOrder = (order, username) => {
  return instance
    .post(`/orders`, {
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
