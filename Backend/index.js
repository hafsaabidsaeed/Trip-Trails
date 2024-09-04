// server.js
const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const placesRouter = require('./routes/placesRoutes');

// Connect Database
connectToDb(); 

// Init Middleware
app.use(express.json());

// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/places', placesRouter);

const PORT = process.env.PORT || 5007;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

