module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define(
    'User',
    {
      name: DataTypes.STRING,
      username: DataTypes.STRING,
      account_type: DataTypes.STRING,
      email: DataTypes.STRING,
      phone: DataTypes.STRING,
      password: DataTypes.STRING,
      status: DataTypes.STRING,
      role: DataTypes.STRING,
      account_id: DataTypes.STRING,         
      accessTo: DataTypes.STRING,
      functionalities: DataTypes.STRING,  
    },
    {
      tableName: 'users',
    }
  );

  User.associate = function (models) {
    // associations can be defined here
  };

  return User;
};
