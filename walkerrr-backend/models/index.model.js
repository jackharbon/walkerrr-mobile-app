const mongoose = require('mongoose');
const db = require('../db/connection');
const { User } = require('./User');

function insertUser(user) {
	const newUser = new User(user);
	return newUser.save();
}

function fetchUsers() {
	const users = User.find();
	return users;
}

function fetchUserById(id) {
	const user = User.find({ uid: id });
	return user;
}

function deleteUserById(id) {
	const user = User.findOneAndDelete({ uid: id });
	return user;
}

function changeUserById(id, body) {
	const user = User.findOneAndUpdate({ uid: id }, body);
	return user;
}

module.exports = { insertUser, fetchUsers, fetchUserById, deleteUserById, changeUserById };
