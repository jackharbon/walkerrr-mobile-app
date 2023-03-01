const { User } = require('../models/User');

async function addUser() {
	try {
		const newUser = await User.create({
			email: '06@u.uk',
			displayName: 'User 06',
			uid: '06',
		});
		console.log(newUser);

		return newUser;
	} catch (error) {
		console.error(error.message);
	}
}

async function updateUser() {
	try {
		const updatedUser = await User.findOne({ displayName: 'User 01' });
		console.log(updatedUser);
		await updatedUser.save();
		console.log(updatedUser);

		return updatedUser;
	} catch (error) {
		console.error(error.message);
	}
}

async function findAll() {
	try {
		const allUsers = await User.find();
		console.log(allUsers);

		return allUsers;
	} catch (error) {
		console.error(error.message);
	}
}

async function namedEmail06() {
	try {
		const user06 = await User.findOne({ displayName: 'User 06' });

		console.log(user06.namedEmail);

		return user06;
	} catch (error) {
		console.error(error.message);
	}
}

// addUser();
updateUser();
// findAll();
// namedEmail06();

module.exports = { addUser, updateUser, findAll, namedEmail06 };
