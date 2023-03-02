const { User } = require('../models/User');

async function addUser() {
	try {
		const newUser = await User.create({
			email: '01@u.uk',
			displayName: 'User 01',
			uid: '01',
		});
		console.log(newUser);

		return newUser;
	} catch (error) {
		console.error(error.message);
	}
}

async function findUser() {
	try {
		const fetchedUser = await User.find({ uid: '01' });
		console.log(fetchedUser);

		return fetchedUser;
	} catch (error) {
		console.error(error.message);
	}
}

async function updateUser() {
	try {
		const updatedUser = await User.findOne({ displayName: 'User 01 new' });
		console.log('findOne User 01 new ->', updatedUser.displayName);
		updatedUser.displayName = 'User 01';
		await updatedUser.save();
		console.log('save User 01 ->', updatedUser.displayName);

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
// findUser();
// updateUser();
findAll();
// namedEmail06();

module.exports = { addUser, findUser, updateUser, findAll, namedEmail06 };
