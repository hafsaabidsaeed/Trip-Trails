// routes/authRoutes.js
const express = require('express');
const { check } = require('express-validator');
const { signup, login, updateUsers, deleteUser } = require('../controllers/userController');
const { authenticateToken, authorizeRole } = require('../middleware/authMiddleware');

const router = express.Router();

router.post(
    '/signup',
    [
        check('name', 'Name is required').not().isEmpty(),
        check('email', 'Please include a valid email').isEmail(),
        check('password', 'Password must be at least 6 characters').isLength({ min: 6 }),
        check('role', 'Role is required').not().isEmpty(),  // Check that role is provided
        check('role', 'Role must be either admin, user, or staff').isIn(['admin', 'user', 'staff']),  // Validate role value
    ],
    signup
);

router.post(
    '/login',
    [
        check('email', 'Please include a valid email').isEmail(),
        check('password', 'Password is required').exists(),
    ],
    login
);

router.put('/update/:id', updateUsers);

router.get('/get-users', authenticateToken, authorizeRole('admin'), (req, res) => {
    UserSchema.find()
        .then(users => res.json(users))
        .catch(err => res.json(err));
});

router.delete('/delete/:id', authenticateToken, authorizeRole('admin'), deleteUser);

module.exports = router;
