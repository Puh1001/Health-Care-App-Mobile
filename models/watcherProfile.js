const mongoose = require("mongoose");
const User = require("./users");

const watcherProfileSchema = mongoose.Schema({
  dateOfBirth: {
    type: Date,
    requite: true,
    trim: true,
  },
  gender: {
    type: String,
    require: true,
    trim: true,
  },
  phoneNumber: {
    type: String,
    require: true,
    trim: true,
  },
  image: {
    type: String,
    require: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    require: true,
    ref: "User",
  },
});

const watcherProfile = mongoose.model("Profile", watcherProfileSchema);
module.exports = watcherProfile;
