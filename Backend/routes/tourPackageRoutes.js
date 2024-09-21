const express = require('express');
const {
    createTourPackage,
    getTourPackages,
    getTourPackageById,
    updateTourPackage,
    deleteTourPackage
} = require('../controllers/tourPackageController.js');
const upload = require('../configurations/multer'); // Multer for handling image uploads

const router = express.Router();

// Create a tour package (with image upload)
router.post('/add-package', upload, createTourPackage);

// Get all tour packages
router.get('/get-packages', getTourPackages);

// Get a tour package by ID
router.get('/get-package/:id', getTourPackageById);

// Update a tour package     
router.put('/update-package/:id', upload, updateTourPackage);

// Delete a tour package
router.delete('/delete-package/:id', deleteTourPackage);

module.exports = router;
