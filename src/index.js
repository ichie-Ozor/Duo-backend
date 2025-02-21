require("dotenv").config();
const express = require("express");
const passport = require("passport");
const bodyParser = require("body-parser");
const cors = require("cors");
const models = require("./modals");
// const express = require('express');
// const passport = require('passport');
// const bodyParser = require('body-parser');
// const cors = require('cors');
// const models = require('./models')

const app = express();

app.use(bodyParser.json());

let port = process.env.PORT || 44405;

// make express look in the public directory for assets (css/js/img)
app.use(express.static(__dirname + "/public"));

app.use(cors());

// force: true will drop the table if it already exits
// models.sequelize.sync({ force: true }).then(() => {
models.sequelize.sync().then(() => {
  console.log("Drop and Resync with {force: true}");
});

// passport middleware
app.use(passport.initialize());

// passport config
require("./config/passport")(passport);

//default route
app.get("/", (req, res) => res.send("Hello my World"));

require("./routes/user.js")(app);
// require("./routes/create_user.js")(app);

// any routes not specified get sent here
app.all("/*", function (req, res) {
  res.status(404).send("This route does not exist");
});

//create a server
var server = app.listen(port, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log("App listening at http://%s:%s", host, port);
});
