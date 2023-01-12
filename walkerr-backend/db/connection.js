const mongoose = require("mongoose");
require("dotenv").config();

function connectToDb() {
  const mongoDB = process.env.DATABASE_URL;

  mongoose.connect(mongoDB, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });

  const db = mongoose.connection;

  return db;
}

module.exports = { connectToDb };
