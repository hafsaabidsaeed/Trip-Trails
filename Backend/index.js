const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const cityRoutes = require('./routes/placesRoutes');
const tourPackageRoutes = require('./routes/tourPackageRoutes.js');
const cors = require('cors');
const path = require('path'); // Import path module


// Enable CORS for all routes
app.use(cors());


// Connect Database
connectToDb(); 


// Init Middleware
app.use(express.json());

// Serve static files from the uploads directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);
app.use('/api/tour-packages', tourPackageRoutes);

const PORT = process.env.PORT || 5009;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
