const passport = require('passport');
const config = require('../config/config');
const { allowOnly } = require('../services/routesHelper');
const { create, login, findAllUsers,
  findById, update, deleteUser, verifyToken, storeProcedure, getInStock,
  getVip,
  getVibe,
  getOutstock,
  getKitcheen,
  insertIngredient,
  insertMenu,
  insertVibe,
  insertVip,
  getOutVip,
  getOutVibe,
  getMenu,
  insertReception,
  getOutReception,
} = require('../controllers/user');

module.exports = (app) => {
  // create a new user
  app.post(
    '/users/create', create
  );

  // user login
  app.post('/users/login', login);

  //retrieve all users
  app.get(
    '/users',
    passport.authenticate('jwt', {
      session: false
    }),
    allowOnly(config.accessLevels.admin, findAllUsers)
  );

  // retrieve user by id
  app.get(
    '/users/:userId',
    passport.authenticate('jwt', {
      session: false,
    }),
    findById
  );

  // update a user with id
  app.put(
    '/users/:userId',
    passport.authenticate('jwt', {
      session: false,
    }),
    allowOnly(config.accessLevels.user, update)
  );

  // delete a user
  app.delete(
    '/users/:userId',
    passport.authenticate('jwt', {
      session: false,
    }),
    allowOnly(config.accessLevels.admin, deleteUser)
  );
  app.get(
    "/verify-token",
    passport.authenticate("jwt", { session: false }),
    verifyToken
  );

  app.post(
    '/stores', storeProcedure
  );
  app.get(
    '/get/stock', getInStock
  );

  app.get(
    '/get/kitcheen', getKitcheen
  );

  app.get(
    '/get/outstocks', getOutstock
  );

  app.get(
    '/get/vibe', getVibe
  );

  app.get(
    '/get/vip', getVip
  );

  app.post(
    '/insert-menu', insertMenu
  );

  app.post(
    '/insert-ingredient', insertIngredient
  );

  app.post(
    '/insert-vibe', insertVibe
  );

  app.post(
    '/insert-vip', insertVip
  );
  app.post('/insert-reception', insertReception)
  app.get("/get/out-reception", getOutReception)
  app.get("/get/out-vip", getOutVip);
  app.get("/get/out-vibe", getOutVibe);
  app.get("/get/menu", getMenu);
};
