const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const moment = require('moment');
const db = require('../modals');
const User = db.User;
require('dotenv').config();

// load input validation
const validateRegisterForm = require('../validation/register');
const validateLoginForm = require('../validation/login');

// create user
module.exports.create = (req, res) => {
  const { errors, isValid } = validateRegisterForm(req.body);
  let {
    name,
    username,
    account_type,
    email,
    phone,
    password,
    status,
    role,
    accessTo,
    functionalities,
  } = req.body;

  // check validation
  if (!isValid) {
    return res.status(400).json(errors);
  }

  User.findAll({ where: { email } }).then(user => {
    if (user.length) {
      return res.status(400).json({ email: 'Email already exists!' });
    } else {
      let newUser = {
        name,
        username,
        account_type,
        email,
        phone,
        password,
        status,
        role,
        accessTo,
        functionalities,
      };
      bcrypt.genSalt(10, (err, salt) => {
        bcrypt.hash(newUser.password, salt, (err, hash) => {
          if (err) throw err;
          newUser.password = hash;
          User.create(newUser)
            .then(user => {
              res.json({ user });
            })
            .catch(err => {
              res.status(500).json({ err });
            });
        });
      });
    }
  });
};

module.exports.login = (req, res) => {
  const { errors, isValid } = validateLoginForm(req.body);

  // check validation
  if (!isValid) {
    return res.status(400).json(errors);
  }

  const { username, password } = req.body;

  User.findAll({
    where: {
      [Op.or]: [
        { email: username },
        { phone: username }
      ]
    }
  })
    .then(user => {

      //check for user
      if (!user.length) {
        errors.username = 'User not found!';
        return res.status(404).json(errors);
      }

      let originalPassword = user[0].dataValues.password

      //check for password
      console.log({ password, originalPassword });
      bcrypt
        .compare(password, originalPassword)
        .then(isMatch => {
          if (isMatch) {
            // user matched
            console.log('matched!')
            const { id, username, role, accessTo, functionalities,account_id,name,account_type } = user[0].dataValues;
            const payload = { id, username, role, accessTo, functionalities,account_id,name,account_type };

            jwt.sign(payload, process.env.JWT_SECRET_KEY, {
              expiresIn: 3600
            },
              (err, token) => {
                if (err) throw err;
                res.json({
                  success: true,
                  token: 'Bearer ' + token,
                  user: payload,
                });
              });
          } else {
            errors.password = 'Password not correct';
            return res.status(400).json(errors);
          }
        }).catch(err => console.log(err));
    }).catch(err => res.status(500).json({ err }));
};

// fetch all users
module.exports.findAllUsers = (req, res) => {
  User.findAll()
    .then(user => {
      res.json({ user });
    })
    .catch(err => res.status(500).json({ err }));
};

// fetch user by userId
module.exports.findById = (req, res) => {
  const id = req.params.userId;

  User.findAll({ where: { id } })
    .then(user => {
      if (!user.length) {
        return res.json({ msg: 'user not found' })
      }
      res.json({ user })
    })
    .catch(err => res.status(500).json({ err }));
};

// update a user's info
module.exports.update = (req, res) => {
  let { firstname, lastname, HospitalId, role, image } = req.body;
  const id = req.params.userId;

  User.update(
    {
      firstname,
      lastname,
      role,
    },
    { where: { id } }
  )
    .then(user => res.status(200).json({ user }))
    .catch(err => res.status(500).json({ err }));
};

// delete a user
module.exports.deleteUser = (req, res) => {
  const id = req.params.userId;

  User.destroy({ where: { id } })
    .then(() => res.status.json({ msg: 'User has been deleted successfully!' }))
    .catch(err => res.status(500).json({ msg: 'Failed to delete!' }));
};


module.exports.verifyToken = async function (req, res) {
  const authToken = req.headers["authorization"];
  console.log(authToken)

  if (!authToken || !authToken.startsWith("Bearer ")) {
      console.log(authToken, 'inside');
    return res.status(401).json({
      
      success: false,
      msg: "Invalid or missing token",
    });
  }

  const token = authToken.slice(7);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
    const { id,account_id} = decoded;
    console.log(id,account_id)

    const user = await db.User.findOne({
      where: {
        id,
      },
      attributes: ['id', 'username', 'role', 'accessTo', 'functionalities', 'account_id']
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        msg: "User not found",
      });
    }

    // Assuming you want to retrieve additional profile data based on the user's role
    const profile = await db.sequelize.query(
      `SELECT * FROM users WHERE account_id='${user.account_id}'`
    );

    res.json({
      success: true,
      user,  // This now includes accessTo and functionalities
      profile: profile[0],
    });
  } catch (err) {
    console.error(err);
    return res.status(401).json({
      success: false,
      msg: "Failed to authenticate token",
    });
  }
};


module.exports.storeProcedure = (req, res) => {
  const {
    id = 0,
    query_type = "",
    item_name = "",
    output_item_name = "",
    destination = "",
    item_cost = "",
    date_of_collection = "",
    invoice = "",
    name_of_collector = "",
    name_of_giver = "",
    in_qty = 0,
    out_qty = 0,
    date = moment().format("YYYY-MM-DD"), 
    vibe_user_name = "",
    vibe_item_name = "",
    vibe_item_price = "",
    vibe_item_qty = 0,
    vip_user_name = "",
    vip_item_name = "",
    vip_item_price = "",
    vip_item_qty = 0,
    kitchen_user_name = "",
    kitchen_item_name = "",
    kitchen_item_price = "",
    kitchen_item_qty = 0,
    status = ""
  } = req.body;

  console.log("Received date:", date);

  db.sequelize
    .query(
      `CALL store_procedure(
        :id,
        :query_type,
        :item_name,
        :output_item_name,
        :destination,
        :item_cost,
        :date_of_collection,
        :invoice,
        :name_of_collector,
        :name_of_giver,
        :in_qty,
        :out_qty,
        :date,
        :vibe_user_name,
        :vibe_item_name,
        :vibe_item_price,
        :vibe_item_qty,
        :vip_user_name,
        :vip_item_name,
        :vip_item_price,
        :vip_item_qty,
        :kitchen_user_name,
        :kitchen_item_name,
        :kitchen_item_price,
        :kitchen_item_qty,
        :status
      )`,
      {
        replacements: {
          id,
          query_type,
          item_name,
          output_item_name,
          destination,
          item_cost,
          date_of_collection,
          invoice,
          name_of_collector,
          name_of_giver,
          in_qty,
          out_qty,
          date,
          vibe_user_name,
          vibe_item_name,
          vibe_item_price,
          vibe_item_qty,
          vip_user_name,
          vip_item_name,
          vip_item_price,
          vip_item_qty,
          kitchen_user_name,
          kitchen_item_name,
          kitchen_item_price,
          kitchen_item_qty,
          status
        },
      }
    )
    .then((results) => {
      req.results = results;
      res.json({ success: true, results }); 
    })
    .catch((err) => {
      console.error("Error executing procedure:", err);
      res.status(500).json({ error: "Database error", details: err });
    });
};

module.exports.getInStock = (req, res) => {
  db.sequelize
    .query("SELECT * FROM in_stock", { type: db.Sequelize.QueryTypes.SELECT })
    .then((results) => {
      res.status(200).json({
        success: true,
        data: results
      });
    })
    .catch((err) => {
      console.error("Error fetching in_stock records:", err);
      res.status(500).json({
        success: false,
        message: "Failed to retrieve in_stock records",
        error: err
      });
    });
};

module.exports.getKitcheen = (req, res) => {
  db.sequelize
    .query("SELECT * FROM kitchen_table", { type: db.Sequelize.QueryTypes.SELECT })
    .then((results) => {
      res.status(200).json({
        success: true,
        data: results
      });
    })
    .catch((err) => {
      console.error("Error fetching in_stock records:", err);
      res.status(500).json({
        success: false,
        message: "Failed to retrieve in_stock records",
        error: err
      });
    });
};

module.exports.getOutstock = (req, res) => {
  db.sequelize
    .query("SELECT * FROM outstock_table", { type: db.Sequelize.QueryTypes.SELECT })
    .then((results) => {
      res.status(200).json({
        success: true,
        data: results
      });
    })
    .catch((err) => {
      console.error("Error fetching in_stock records:", err);
      res.status(500).json({
        success: false,
        message: "Failed to retrieve in_stock records",
        error: err
      });
    });
};

module.exports.getVibe = (req, res) => {
  db.sequelize
    .query("SELECT * FROM vibe_table", { type: db.Sequelize.QueryTypes.SELECT })
    .then((results) => {
      res.status(200).json({
        success: true,
        data: results
      });
    })
    .catch((err) => {
      console.error("Error fetching in_stock records:", err);
      res.status(500).json({
        success: false,
        message: "Failed to retrieve in_stock records",
        error: err
      });
    });
};

module.exports.getVip = (req, res) => {
  db.sequelize
    .query("SELECT * FROM vip_table", { type: db.Sequelize.QueryTypes.SELECT })
    .then((results) => {
      res.status(200).json({
        success: true,
        data: results
      });
    })
    .catch((err) => {
      console.error("Error fetching in_stock records:", err);
      res.status(500).json({
        success: false,
        message: "Failed to retrieve in_stock records",
        error: err
      });
    });
};

module.exports.insertMenu = (req, res) => {
  const {
    menu_name = "",
    menu_price = ""
  } = req.body;

  db.sequelize
    .query(
      `CALL menu_ingredient(
        :query_type,
        :menu_name,
        :menu_price,
        null
      )`,
      {
        replacements: {
          query_type: "insert_menu",
          menu_name,
          menu_price
        },
      }
    )
    .then((results) => {
      res.json({ success: true, message: "Menu item inserted successfully", results });
    })
    .catch((err) => {
      console.error("Error inserting menu:", err);
      res.status(500).json({ error: "Database error", details: err });
    });
};

module.exports.insertIngredient = (req, res) => {
  const {
    menu_name = "",
    menu_ingredients = ""
  } = req.body;

  db.sequelize
    .query(
      `CALL menu_ingredient(
        :query_type,
        :menu_name,
        null,
        :menu_ingredients
      )`,
      {
        replacements: {
          query_type: "insert_ingredient",
          menu_name,
          menu_ingredients
        },
      }
    )
    .then((results) => {
      res.json({ success: true, message: "Ingredients inserted successfully", results });
    })
    .catch((err) => {
      console.error("Error inserting ingredients:", err);
      res.status(500).json({ error: "Database error", details: err });
    });
};



// module.exports.insertMenu = (req, res) => {
//   const { menu_name, menu_price } = req.body;
//   db.sequelize
//     .query(
//     `INSERT INTO menu_table (menu_name, menu_price) VALUES ('${menu_name}', '${menu_price}')`
//     )
//     .then((results) => {
//       res.status(200).json({ message: 'Menu item inserted successfully' });
//     })
//     .catch((err) => {
//       console.error("Error inserting menu item:", err);
//       res.status(500).json({ message: 'Error inserting menu item', error: err });
//     });
// }
