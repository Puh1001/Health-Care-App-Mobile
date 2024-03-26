//import from pakage
const express = require("express");
const mongoose = require("mongoose");
const morgan = require("morgan");
const app = express();

require("dotenv").config();

//import from another files
const authRouter = require("./routers/auth");
const watcherRouter = require("./routers/watcher");
const heathDataRouter = require("./routers/heathData");
const profileRouter = require("./routers/Profile");
const port = process.env.PORT || 8080;
const hostname = process.env.HOST_NAME;
const DB = process.env.DATABASE_URL;
app.use(express.json());

app.use(express.urlencoded({ extended: true }));

//middleware
app.use(authRouter);
app.use(heathDataRouter);
app.use(watcherRouter);
app.use(profileRouter);
//connection
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connect Sucessfully !!!!");
  })
  .catch((err) => {
    console.log(err);
  });

app.use(morgan("combined"));

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, "0.0.0.0", () => {
  console.log(`App listening at http://localhost:${port}`);
});
