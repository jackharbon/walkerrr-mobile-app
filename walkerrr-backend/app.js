const express = require('express');
const { postUser, getAllUsers, getUserById, removeUser, patchUserById } = require('./controllers/index.controller');
const app = express();
const cors = require('cors');
const { User } = require('./models/User');

const bodyParser = require('body-parser');
app.use(bodyParser.json({ extended: true }));
app.use(bodyParser.urlencoded({ extended: true }));

app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
	res.status(200).send({ message: 'Walkerrr app backend ready' });
});
app.get('/api/users/', getAllUsers);
app.get('/api/users/:user_id', getUserById);
app.post('/api/users', postUser);
app.delete('/api/users/:user_id', removeUser);
app.patch('/api/users/:user_id', patchUserById);

module.exports = app;
