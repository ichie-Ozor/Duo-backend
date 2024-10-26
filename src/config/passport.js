const { ExtractJwt } = require('passport-jwt')
const JwtStrategy = require('passport-jwt').Strategy
const models = require('../modals')
require('dotenv').config();

const Users = models.User;

const opts = {};
opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken();
opts.secretOrKey = process.env.JWT_SECRET_KEY;

module.exports = passport => {
  passport.use(
    new JwtStrategy(opts, (jwt_payload, done) => {
      Users.findAll({ where: { id: jwt_payload.id } })
        .then(user => {
          if (user.length) {
            return done(null, user);
          }
          return done(null, false);
        })
        .catch(err => console.log(err));
    })
  );
};
