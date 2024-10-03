// controllers/bookingController.js
const Booking = require('../models/bookingModel');

// @desc    Create a new booking
// @route   POST /api/bookings
exports.createBooking = async (req, res) => {
  try {
    const { name, email, phoneNumber, tourType, ticketType, tourDate, numberOfPeople } = req.body;

    // Basic validation
    if (!name || !email || !phoneNumber || !tourType || !ticketType || !tourDate || !numberOfPeople) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const newBooking = new Booking({
      name,
      email,
      phoneNumber,
      tourType,
      ticketType,
      tourDate,
      numberOfPeople,
    });

    await newBooking.save();
    res.status(201).json(newBooking);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};

// @desc    Get all bookings
// @route   GET /api/bookings
exports.getAllBookings = async (req, res) => {
  try {
    const bookings = await Booking.find();
    res.json(bookings);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};

// @desc    Get a single booking by ID
// @route   GET /api/bookings/:id
exports.getBookingById = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.json(booking);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};

// @desc    Delete a booking
// @route   DELETE /api/bookings/:id
exports.deleteBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    await booking.remove();
    res.json({ message: 'Booking deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};

// @desc    Update a booking
// @route   PUT /api/bookings/:id
exports.updateBooking = async (req, res) => {
  try {
    const { name, email, phoneNumber, tourType, ticketType, tourDate, numberOfPeople } = req.body;

    let booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    // Update booking details
    booking.name = name || booking.name;
    booking.email = email || booking.email;
    booking.phoneNumber = phoneNumber || booking.phoneNumber;
    booking.tourType = tourType || booking.tourType;
    booking.ticketType = ticketType || booking.ticketType;
    booking.tourDate = tourDate || booking.tourDate;
    booking.numberOfPeople = numberOfPeople || booking.numberOfPeople;

    await booking.save();
    res.json(booking);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};
