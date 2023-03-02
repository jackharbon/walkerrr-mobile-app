const app = require('./app');
const { connectToDb } = require('./db/connection');

const PORT = 9095;
let db = '';

connectToDb().then(async () => {
	app.listen(PORT, () => {
		console.log(`Listening on port ${PORT}...`);
	});
});

module.exports = db;
