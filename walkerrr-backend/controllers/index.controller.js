const { insertUser, fetchUsers, fetchUserById, deleteUserById, changeUserById } = require('../models/index.model');

exports.getUsers = (req, res, next) => {
	const { user_id } = req.params;
	fetchUsers()
		.then((users) => {
			res.send(users);
		})
		.catch(next);
};

exports.getUserById = (req, res, next) => {
	const { user_id } = req.params;
	fetchUserById(user_id)
		.then((user) => {
			res.send(user);
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
			res.send(user);
		})
		.catch(next);
};

exports.patchUserById = (req, res, next) => {
	const { user_id } = req.params;
	const body = req.body;
	changeUserById(user_id, body)
		.then((user) => {
			res.send(user);
		})
		.catch(next);
};
