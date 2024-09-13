const express = require('express');
const {
    createTourPackage,
    getTourPackages,
    getTourPackageById,
    updateTourPackage,
    deleteTourPackage
} = require('../controllers/tourPackageController.js');

const router = express.Router();

// Create a tour package
router.post('/add-package', createTourPackage);

// Get all tour packages
router.get('/get-packages', getTourPackages);

// Get a tour package by ID
router.get('/get-package/:id', getTourPackageById);

// Update a tour package
router.put('/update-package/:id', updateTourPackage);

// Delete a tour package
router.delete('/delete-package/:id', deleteTourPackage);

module.exports = router;


