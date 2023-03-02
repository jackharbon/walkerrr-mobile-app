const mongoose = require('mongoose');
const db = require('../db/connection');
const { User } = require('./User');

function insertUser(user) {
	const newUser = new User(user);
	return newUser.save();
}

async function fetchUserById(id) {
	const user = await User.find({ uid: id });
	return user;
}

async function deleteUserById(id) {
	const user = await User.findOneAndDelete({ uid: id });
	return user;
}

async function changeUserById(id, body) {
	const user = await User.findOneAndUpdate({ uid: id }, body);
	return user;
}

module.exports = { insertUser, fetchUserById, deleteUserById, changeUserById };
