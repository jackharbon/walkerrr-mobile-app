const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const UserSchema = new Schema({
  email: { type: String, required: true, unique: true },
  displayName: { type: String, required: true },
  uid: { type: String, required: true, unique: true },
  coins: { type: Number, required: true, default: 100 },
  trophies: { type: Array, required: true, default: [] },
  quests: { type: Array, required: true, default: [] },
  equippedArmour: { type: String, default: "basic" },
});

exports.User = mongoose.model("User", UserSchema);
