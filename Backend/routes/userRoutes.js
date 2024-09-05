
const express = require('express');
const { check } = require('express-validator');
const { signup, login, updateUsers } = require('../controllers/userController');


const router = express.Router();

// @route   POST api/auth/signup
// @desc    Register user
// @access  Public
router.post(
    '/signup',
    [
        check('name', 'Name is required').not().isEmpty(),
        check('email', 'Please include a valid email').isEmail(),
        check('password', 'Password must be at least 6 characters').isLength({ min: 6 }),
    ],
    signup
);

// @route   POST api/auth/login
// @desc    Authenticate user & get token
// @access  Public
router.post(
    '/login',
    [
        check('email', 'Please include a valid email').isEmail(),
        check('password', 'Password is required').exists(),
    ],
    login
);

// @route   PUT api/auth/update/:id
// @desc    Update user
// @access  Private
router.put(
    '/update/:id',
     updateUsers
    );

module.exports = router;