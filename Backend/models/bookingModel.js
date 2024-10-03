// models/Booking.js
const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  phoneNumber: { type: String, required: true },  // Store as a string since it's prefixed with +92
  tourType: { type: String, required: true },
  ticketType: { type: String, required: true },
  tourDate: { type: Date, required: false },
  numberOfPeople: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Booking', bookingSchema);
