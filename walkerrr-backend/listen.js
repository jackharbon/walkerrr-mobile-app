const app = require("./app");
const { connectToDb } = require("./db/connection");

const PORT = 9095;
let db = "";

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}...`);
  db = connectToDb();
});

module.exports = db;
