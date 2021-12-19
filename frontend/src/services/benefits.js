import axios from 'axios';

const instance = axios.create({
	baseURL: 'http://localhost:4000/api/v1'
});

export const getUser = username => {
	return instance.get(`/users/${username}`).then(response => {
		const { data } = response;
		return {
			...data.user,
			username: data.user.username
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
				username: username
			}
		})
		.then(response => {
			const { data } = response;
			return data;
		});
};
