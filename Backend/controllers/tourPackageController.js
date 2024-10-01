const TourPackage = require('../models/tourPackageModel.js');

// Create a tour package and associate it with a city
exports.createTourPackage = async (req, res) => {
    try {
        const { title, description, price, duration, location, startDate, endDate, packageType, cityId } = req.body;

        // Collect the paths of uploaded images from req.files
        let imagePaths = req.files ? req.files.map(file => `/uploads/${file.filename}`) : [];

        const newPackage = new TourPackage({
            title,
            description,
            price,
            duration,
            location,
            startDate,
            endDate,
            packageType,
            images: imagePaths,
            city: cityId  // Reference to the city
        });

        const savedPackage = await newPackage.save();

        // Update the city to include this package
        const city = await City.findById(cityId);
        if (!city) {
            return res.status(404).json({ message: 'City not found' });
        }
        city.tourPackages.push(savedPackage._id);
        await city.save();

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

// Get all tour packages for a specific city
exports.getTourPackagesByCity = async (req, res) => {
    try {
        const tourPackages = await TourPackage.find({ city: req.params.cityId }); // Find packages for a specific city

        if (!tourPackages.length) {
            return res.status(404).json({ message: 'No tour packages found for this city' });
        }

        res.status(200).json(tourPackages);
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};


exports.updateTourPackage = async (req, res) => {
    try {
        const { title, description, price, duration, location, startDate, endDate, packageType } = req.body;

        // Find the package by ID
        let tourPackage = await TourPackage.findById(req.params.id);
        if (!tourPackage) {
            return res.status(404).json({ message: 'Tour Package not found' });
        }

        // Collect new image paths if any images were uploaded
        let newImagePaths = req.files ? req.files.map(file => `/uploads/${file.filename}`) : [];

        // Merge existing images with new images if they exist
        let updatedImages = [...tourPackage.images, ...newImagePaths];

        // Update the package with new details and merged image paths
        tourPackage.title = title;
        tourPackage.description = description;
        tourPackage.price = price;
        tourPackage.duration = duration;
        tourPackage.location = location;
        tourPackage.startDate = startDate;
        tourPackage.endDate = endDate;
        tourPackage.packageType = packageType;
        tourPackage.images = updatedImages; // Preserve both old and new images

        // Save the updated package
        const updatedPackage = await tourPackage.save();
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
