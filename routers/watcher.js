const express = require("express");
const watcherRouter = express.Router();
const auth = require("../middlewares/auth");
const User = require("../models/users");
const Profile = require("../models/Profile");
const HeathData = require("../models/heathData");

//GET ALL PATIENT
watcherRouter.get("/watcher/get-all-patient", auth, async (req, res) => {
  try {
    const patient = await User.find({ watcherId: req.query.watcherId });
    res.json(patient);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
// DELETE PATIENT
watcherRouter.post("/watcher/delete-patient", auth, async (req, res) => {
  try {
    let user = await User.findOneAndDelete({ _id: req.query.userId });
    let profile = await Profile.findOneAndDelete({ userId: req.query.userId });
    let heathData = await HeathData.deleteMany({ userId: req.query.userId });

    res.json(user, profile, heathData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
module.exports = watcherRouter;
