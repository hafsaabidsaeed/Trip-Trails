const TourPackage = require('../models/tourPackageModel.js');

// Create a tour package
exports.createTourPackage = async (req, res) => {
    try {
        const newPackage = new TourPackage(req.body);
        const savedPackage = await newPackage.save();
        res.status(201).json(savedPackage);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

// Get all tour packages
exports.getTourPackages = async (req, res) => {
    try {
        const packages = await TourPackage.find();
        res.json(packages);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Get a specific tour package by ID
exports.getTourPackageById = async (req, res) => {
    try {
        const tourPackage = await TourPackage.findById(req.params.id);
        if (!tourPackage) {
            return res.status(404).json({ message: 'Tour Package not found' });
        }
        res.json(tourPackage);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Update a tour package
exports.updateTourPackage = async (req, res) => {
    try {
        const updatedPackage = await TourPackage.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedPackage) {
            return res.status(404).json({ message: 'Tour Package not found' });
        }
        res.json(updatedPackage);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};

// Delete a tour package
exports.deleteTourPackage = async (req, res) => {
    try {
        const tourPackage = await TourPackage.findByIdAndDelete(req.params.id);
        if (!tourPackage) {
            return res.status(404).json({ message: 'Tour Package not found' });
        }
        res.json({ message: 'Tour Package deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
