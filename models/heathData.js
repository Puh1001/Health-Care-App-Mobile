const mongoose = require("mongoose");

const heathDataSchema = mongoose.Schema({
  heartRate: {
    require: true,
    type: Number,
    trim: true,
  },
  spb: {
    require: true,
    type: Number,
    trim: true,
  },
  dbp: {
    require: true,
    type: Number,
    trim: true,
  },
  oxygen: {
    require: true,
    type: Number,
    trim: true,
  },
  temperature: {
    require: true,
    type: Number,
    trim: true,
  },
  glucose: {
    require: true,
    type: Number,
    trim: true,
  },
  step: {
    require: true,
    type: Number,
    trim: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    require: true,
    ref: "User",
  },
  timestamp: {
    type: Date,
    required: true,
    trim: true,
  },
});

const HeathData = mongoose.model("HeathData", heathDataSchema);
module.exports = HeathData;
