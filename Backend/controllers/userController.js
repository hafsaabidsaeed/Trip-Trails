// controllers/authController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/user');
require('dotenv').config();

exports.signup = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password, role } = req.body;

    try {
        // Check if a user with the same email and role already exists
        let existingUser = await User.findOne({ email, name, role });

        if (existingUser) {
            // If all three fields match, prevent account creation
            return res.status(400).json({ msg: 'User with this email, username, and role already exists' });
        }

        // Check if a user with the same email but different role exists
        existingUser = await User.findOne({ email, name });
        if (existingUser && existingUser.role !== role) {
            // Allow account creation if the role is different
            const newUser = new User({
                name,
                email,
                password,
                role,
            });

            const salt = await bcrypt.genSalt(10);
            newUser.password = await bcrypt.hash(password, salt);

            await newUser.save();

            const payload = {
                user: {
                    id: newUser.id,
                    role: newUser.role,
                },
            };


            jwt.sign(
                payload,
                process.env.JWT_SECRET,
                { expiresIn: 360000 },
                (err, token) => {
                    if (err) throw err;
                    res.json({ token });
                }
            );
        } else {
            // Proceed if no such user exists
            const newUser = new User({
                name,
                email,
                password,
                role,
            });


            const salt = await bcrypt.genSalt(10);
            newUser.password = await bcrypt.hash(password, salt);


            await newUser.save();


            const payload = {
                user: {
                    id: newUser.id,
                    role: newUser.role,
                },
            };

            jwt.sign(
                payload,
                process.env.JWT_SECRET,
                { expiresIn: 360000 },
                (err, token) => {
                    if (err) throw err;
                    res.json({ token });
                }
            );
        }
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};



exports.login = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
        let user = await User.findOne({ email });

        if (!user) {
            return res.status(400).json({ msg: 'Invalid Credentials' });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ msg: 'Invalid Credentials' });
        }

        const payload = {
            user: {
                id: user.id,
                role: user.role,  // Include role in payload
            },
        };

        jwt.sign(
            payload,
            process.env.JWT_SECRET,
            { expiresIn: 360000 },
            (err, token) => {
                if (err) throw err;
                // Redirect based on role
                let redirectUrl;
                switch (user.role) {
                    case 'admin':
                        redirectUrl = '/admin';
                        break;
                    case 'staff':
                        redirectUrl = '/dashboard';
                        break;
                    default:
                        redirectUrl = '/user';
                }
                res.json({ token, redirectUrl });
            }
        );
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};


// Update a user's information
exports.updateUsers = async (req, res) => {
    const { id } = req.params;
    const { name, email, password } = req.body;

    try {
        const updateData = { name, email };

        if (password) {
            const salt = await bcrypt.genSalt(10);
            updateData.password = await bcrypt.hash(password, salt);
        }

        const user = await User.findByIdAndUpdate(id, updateData, { new: true });

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        // Return the updated user
        res.status(200).json({
            success: true,
            message: "User updated successfully",
            data: user
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            message: "Failed to update user",
            error: err.message
        });
    }
};

// Get all users from the database  
exports.getUsers = async (req, res) => {
    try {
        const users = await User.find({});
        res.status(200).json({
            success: true,
            message: "Users retrieved successfully",
            data: users
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: "Failed to retrieve users",
            error: err.message
        });
    }
};

// Delete a user by ID
exports.deleteUser = async (req, res) => {
    const { id } = req.params;

    try {
        const user = await User.findByIdAndDelete(id);

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        res.status(200).json({
            success: true,
            message: "User deleted successfully",
            data: user
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: "Failed to delete user",
            error: err.message
        });
    }
};
