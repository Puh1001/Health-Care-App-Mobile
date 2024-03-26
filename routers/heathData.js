const express = require("express");
const heathDataRouter = express.Router();
const HeathData = require("../models/heathData");
const auth = require("../middlewares/auth");

// SAVE DATA
heathDataRouter.post("/api/heath-data", async (req, res) => {
  try {
    const {
      heartRate,
      spb,
      dbp,
      oxygen,
      temperature,
      glucose,
      step,
      userId,
      timestamp,
    } = req.body;
    let heathData = new HeathData({
      heartRate,
      spb,
      dbp,
      oxygen,
      temperature,
      glucose,
      step,
      userId,
      timestamp,
    });
    heathData = await heathData.save();
    res.json(heathData);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET ALL DATA (modified)
heathDataRouter.get("/api/get-heath-data", auth, async (req, res) => {
  try {
    const heathData = await HeathData.find({ userId: req.query.userId });
    res.json(heathData);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = heathDataRouter;
