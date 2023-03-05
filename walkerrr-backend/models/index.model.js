const mongoose = require('mongoose');
const db = require('../db/connection');
const { User } = require('./User');

async function fetchAllUsers() {
	const users = await User.find();
	return users;
}

async function fetchUserById(id) {
	const user = await User.find({ uid: id });
	return user;
}

async function insertUser(user) {
	const newUser = new User(user);
	return newUser.save();
}

async function deleteUserById(id) {
	const user = await User.findOneAndDelete({ uid: id });
	return user;
}

async function changeUserById(id, body) {
	const { email, displayName, coins, trophies, quests, equippedArmour } = body;
	const user = await User.findOne({ uid: id });
	if (email) user.email = email;
	if (displayName) user.displayName = displayName;
	if (coins) user.coins = coins;
	if (trophies) user.trophies = trophies;
	if (quests) user.quests = quests;
	if (equippedArmour) user.equippedArmour = equippedArmour;
	await user.save();
	const updatedUser = await User.findOne({ uid: id });
	return updatedUser;
}

module.exports = { insertUser, fetchAllUsers, fetchUserById, deleteUserById, changeUserById };
