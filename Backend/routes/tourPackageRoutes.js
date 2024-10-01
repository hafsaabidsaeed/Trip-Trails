const express = require('express');
const upload = require('../configurations/multer');
const {
    createTourPackage,
    getTourPackages,
    getTourPackageById,
    updateTourPackage,
    deleteTourPackage,
    getTourPackagesByCity // New controller to get packages by city
} = require('../controllers/tourPackageController');

const router = express.Router();

// Create a new tour package (with image upload)
router.post('/add-package', upload, createTourPackage);

// Get all tour packages
router.get('/get-packages', getTourPackages);

// Get all tour packages for a specific city
router.get('/get-packages-by-city/:cityId', getTourPackagesByCity); // New route

// Get a specific tour package by ID
router.get('/get-package/:id', getTourPackageById);

// Update a tour package (with image upload)
router.put('/update-package/:id', upload, updateTourPackage);

// Delete a tour package
router.delete('/delete-package/:id', deleteTourPackage);

module.exports = router;
