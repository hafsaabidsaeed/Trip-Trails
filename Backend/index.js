const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const path = require('path');
const cors = require('cors');
const cityRoutes = require('./routes/placesRoutes');
const tourPackageRoutes = require('./routes/tourPackageRoutes');
const bookingRoutes = require('./routes/bookingRoutes');
const app = express();

// Enable CORS for all routes
app.use(cors());

// Init Middleware (Place this before your route definitions)
app.use(express.json()); // Parses incoming requests with JSON payloads

// Connect Database
connectToDb();

// Serve static files from the "uploads" directory for images
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);
app.use('/api/tour-packages', tourPackageRoutes);
app.use('/api/bookings', bookingRoutes); // Moved after the middleware

const PORT = process.env.PORT || 5009;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
