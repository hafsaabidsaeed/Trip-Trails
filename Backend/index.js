const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const cityRoutes = require('./routes/cityRoutes');
const tourPackageRoutes = require('./routes/tourPackageRoutes.js');


// Connect Database
connectToDb(); 

// Init Middleware
app.use(express.json());

// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);
app.use('/api/tour-packages', tourPackageRoutes);

const PORT = process.env.PORT || 5010;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));