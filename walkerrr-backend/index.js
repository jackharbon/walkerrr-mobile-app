const express = require('express');
const { postUser, getUserById, removeUser, patchUserById } = require('./controllers/index.controller');
const app = express();
const cors = require('cors');
const { User } = require('./models/User');

// ! testing new lines
const bodyParser = require('body-parser');
app.use(bodyParser.json({ extended: true }));
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
	res.send('Walkerrr app backend');
});
app.get('/api/users', async (req, res) => {
	const users = await User.find();
	console.log('🚀 -> app.get -> users:', users);
	if (users) {
		res.json(users);
	} else {
		res.status(404).send({ message: 'No users found' });
	}
});
app.get('/api/users/:user_id', getUserById);
app.post('/api/users', postUser);
app.delete('/api/users/:user_id', removeUser);
app.patch('/api/users/:user_id', patchUserById);

module.exports = app;
