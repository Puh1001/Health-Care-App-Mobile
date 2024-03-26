const express = require("express");
const profileRouter = express.Router();
const auth = require("../middlewares/auth");
const watcher = require("../middlewares/watcher");
const Profile = require("../models/Profile");
// ADD PATIENT PROFILE
// ADD PATIENT PROFILE
profileRouter.post("/api/add-profile", auth, async (req, res) => {
  try {
    const {
      dateOfBirth,
      gender,
      phoneNumber,
      bloodType,
      image,
      height,
      weight,
      userId,
    } = req.body;
    let profile = new Profile({
      dateOfBirth,
      gender,
      phoneNumber,
      image,
      bloodType,
      height,
      weight,
      userId,
    });
    profile = await profile.save();
    res.json(profile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET PROFILE USER
profileRouter.get("/api/get-profile", async (req, res) => {
  try {
    const profile = await Profile.find({ userId: req.query.userId });
    res.json(profile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
// UPDATE PROFILE
profileRouter.patch("/api/update-profile", async (req, res) => {
  try {
    const updateProfile = await Profile.findOneAndUpdate(
      { userId: req.query.userId },
      {
        dateOfBirth: req.body.dateOfBirth,
        gender: req.body.gender,
        phoneNumber: req.body.phoneNumber,
        bloodType: req.body.bloodType,
        image: req.body.image,
        height: req.body.height,
        weight: req.body.weight,
      },
      { new: true }
    );
    res.status(200).json({ message: "Updated user", data: updateProfile });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ADD WATCHER PROFILE
profileRouter.post("/api/add-watcher-profile", auth, async (req, res) => {
  try {
    const { dateOfBirth, gender, phoneNumber, image, userId } = req.body;
    let watcherProfile = new WatcherProfile({
      dateOfBirth,
      gender,
      phoneNumber,
      image,
      userId,
    });
    watcherProfile = await watcherProfile.save();
    res.json(profile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET PROFILE USER( WATCHER)
profileRouter.get("/api/get-watcher-profile", auth, async (req, res) => {
  try {
    const WatcherProfile = await WatcherProfile.find({
      userId: req.query.userId,
    });
    res.json(profile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
module.exports = profileRouter;
