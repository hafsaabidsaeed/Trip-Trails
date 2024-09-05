const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const cityRoutes = require('./routes/cityRoutes');

// Connect Database
connectToDb(); 

// Init Middleware
app.use(express.json());

// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);

const PORT = process.env.PORT || 5010;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));