const express = require('express');
const { postUser, getUserById, removeUser, patchUserById } = require('./controllers/index.controller');
const app = express();
const cors = require('cors');

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
	res.send('Walkerrr app backend');
});
app.get('/api/users', async (req, res) => {
	const users = await User.find();
	if (users) {
		res(users);
	} else {
		res.status(404).json({ message: 'No users found' });
	}
});
app.get('/api/users/:user_id', getUserById);
app.post('/api/users', postUser);
app.delete('/api/users/:user_id', removeUser);
app.patch('/api/users/:user_id', patchUserById);

module.exports = app;
