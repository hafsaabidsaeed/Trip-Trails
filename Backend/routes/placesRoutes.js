const express = require('express');
const {
    createCity,
    getCities,
    getCityById,
    updateCity,
    deleteCity,
} = require('../controllers/placesController');
const upload = require('../configurations/multer'); // Multer for handling image uploads

const router = express.Router();

// Create a city (with image upload)
router.post('/add-city', upload, createCity);

// Get all cities
router.get('/get-cities', getCities);

// Get a city by ID (with associated tour packages populated)
router.get('/get-one-city/:id', getCityById);

// Update a city (with image upload)
router.put('/update-city/:id', upload, updateCity);

// Delete a city
router.delete('/delete-city/:id', deleteCity);

module.exports = router;
