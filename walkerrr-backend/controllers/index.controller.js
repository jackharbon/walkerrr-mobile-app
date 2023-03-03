const { insertUser, fetchAllUsers, fetchUserById, deleteUserById, changeUserById } = require('../models/index.model');

exports.getAllUsers = (req, res, next) => {
	fetchAllUsers()
		.then((users) => {
			if (users.length !== 0) {
				res.status(200).json(users);
			} else {
				res.status(404).send({ message: 'No users found' });
			}
		})
		.catch(next);
};

exports.getUserById = (req, res, next) => {
	const { user_id } = req.params;
	fetchUserById(user_id)
		.then((user) => {
			res.status(200).send(user);
		})
		.catch(next);
};

exports.postUser = (req, res, next) => {
	const user = req.body;
	insertUser(user)
		.then((newUser) => {
			res.status(201).send(newUser);
		})
		.catch(next);
};

exports.removeUser = (req, res, next) => {
	const { user_id } = req.params;
	deleteUserById(user_id)
		.then((user) => {
			res.status(204).send({ message: 'User deleted' });
		})
		.catch(next);
};

exports.patchUserById = (req, res, next) => {
	const { user_id } = req.params;
	const body = req.body;
	changeUserById(user_id, body)
		.then((user) => {
			res.status(200).send(user);
		})
		.catch(next);
};
