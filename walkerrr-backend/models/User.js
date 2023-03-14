const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
	email: { type: String, required: true, unique: true, lowercase: true, minLength: 5 },
	displayName: { type: String, required: true },
	uid: { type: String, immutable: true, required: true, unique: true },
	coins: { type: Number, required: true, default: 0 },
	trophies: { type: Array, required: true, default: [] },
	quests: { type: Array, required: true, default: [] },
	equippedArmour: { type: String, default: 'basic' },
	createdAt: { type: Date, immutable: true, default: Date.now },
	updatedAt: { type: Date, default: Date.now },
});

UserSchema.virtual('namedEmail').get(function () {
	return `${this.displayName} <${this.email}>`;
});

UserSchema.pre('save', function (next) {
	this.updatedAt = Date.now();
	next();
});

exports.User = mongoose.model('User', UserSchema);
