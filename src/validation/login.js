const Validator = require('validator');
const isEmpty = require('./isEmpty');

function validateLoginForm(data) {
  let errors = {};

  data.username = !isEmpty(data.username) ? data.username : '';
  data.password = !isEmpty(data.password) ? data.password : '';

  if (!Validator.isLength(data.username, { min: 3, max: 50 })) {
    errors.username = 'Username is invalid';
  }

  if (Validator.isEmpty(data.username)) {
    errors.username = 'Username is required';
  }

  if (Validator.isEmpty(data.password)) {
    errors.password = 'Password is required';
  }

  return {
    errors,
    isValid: isEmpty(errors),
  };
};

module.exports = validateLoginForm