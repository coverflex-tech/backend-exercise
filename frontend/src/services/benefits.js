import axios from 'axios';

const instance = axios.create({
  baseURL: '/api'
});

const createUser = username => {
  return instance
    .post(`/users`, {
      user: {
        user_id: username,
        balance: 250.00
      }
    })
    .then(response => {
      const { data } = response;
      return {
        user_id: data.user.user_id,
        ...data.user.data
      };
    });
};

export const getUser = username => {
  return instance.get(`/users/${username}`)
    .then(response => {
      console.log(response)
      const { data } = response;
      return {
        user_id: data.user.user_id,
        ...data.user.data
      };
    })
    .catch(error => {
      if (error.response.status === 404) {
        return createUser(username);
      } else {
        throw error;
      }
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
