import axios from 'axios';

const instance = axios.create({
  /**
   * Instead of hardcoding the URL here, what would be a better and more secure approach.
   */
  baseURL: 'https://coverflex-hiring-exercise.herokuapp.com/api' // Insert here backend env URL
});


/**
 * What would be your error handling approach?
 */
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
