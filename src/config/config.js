var config = module.exports;

const userRoles = config.userRoles = {
    guest: 'guest',
    user: 'user',
    admin: 'admin',
    superAdmin: 'super admin'
}

config.accessLevels = {
    guest: userRoles.guest | userRoles.user | userRoles.admin | userRoles.superAdmin,
    user: userRoles.user | userRoles.admin | userRoles.superAdmin,
    admin: userRoles.admin | userRoles.superAdmin,
    superAdmin: userRoles.superAdmin,
}