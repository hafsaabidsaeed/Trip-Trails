// routes/bookings.js
const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

// @route   POST /api/bookings
// @desc    Create a new booking
router.post('/add-booking', bookingController.createBooking);

// @route   GET /api/bookings
// @desc    Get all bookings
router.get('/get-bookings', bookingController.getAllBookings);

// @route   GET /api/bookings/:id
// @desc    Get a single booking by ID
router.get('/:id', bookingController.getBookingById);

// @route   DELETE /api/bookings/:id
// @desc    Delete a booking
router.delete('/:id', bookingController.deleteBooking);

// @route   PUT /api/bookings/:id
// @desc    Update a booking
router.put('/:id', bookingController.updateBooking);

module.exports = router;
