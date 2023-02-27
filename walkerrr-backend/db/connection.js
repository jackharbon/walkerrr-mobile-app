const mongoose = require('mongoose');
const express = require('express');
require('dotenv').config();
mongoose.set('strictQuery', false);

const mongoDB = process.env.DATABASE_URL;

async function connectToDb() {
	try {
		await mongoose.connect(mongoDB, {
			useNewUrlParser: true,
			useUnifiedTopology: true,
		});
		console.log('Remote MongoDB connected...');
	} catch (error) {
		console.error(error.message);
	}

	const db = mongoose.connection;

	return db;
}

module.exports = { connectToDb };
