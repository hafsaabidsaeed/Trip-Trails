const City = require('../models/placesModel');

// Create a new city
exports.createCity = async (req, res) => {
    try {
      const { name, description, location, date, isFeatured } = req.body;

      // Handle uploaded images if any
      let imagePaths = [];
      if (req.files && req.files.length > 0) {
        imagePaths = req.files.map(file => `/uploads/${file.filename}`);  // Use local file paths
      }

      const newCity = new City({
        name,
        description,
        location,
        images: imagePaths,           // Save an array of image URLs
        isFeatured: isFeatured || false,  // Set as featured or default to false
        commentCount: 0,            // Default to 0 since no comments initially
        date: date ? new Date(date) : null, // Use provided date or null if not provided
      });

      await newCity.save();
      res.status(201).json(newCity);
    } catch (err) {
      res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Get all cities
exports.getCities = async (req, res) => {
    try {
        const cities = await City.find();
        res.status(200).json(cities);
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};

// Get a city with its associated tour packages
exports.getCityById = async (req, res) => {
    try {
        // Populate the tourPackages field to get the actual package details
        const city = await City.findById(req.params.id).populate('tourPackages');

        if (!city) {
            return res.status(404).json({ message: 'City not found' });
        }

        res.status(200).json(city);
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};


// Update city with optional image uploads
exports.updateCity = async (req, res) => {
    try {
        const cityId = req.params.id;
        const { name, description, location, date, isFeatured } = req.body;

        // Get the current city data from the database
        const city = await City.findById(cityId);
        if (!city) {
            return res.status(404).json({ message: 'City not found' });
        }

        // Handle new uploaded images, if any
        let imagePaths = city.images; // Keep existing images by default
        if (req.files && req.files.length > 0) {
            imagePaths = req.files.map(file => `/uploads/${file.filename}`);  // Replace old images with new ones
        }

        // Prepare the updated fields
        const updatedFields = {
          name: name || city.name,
          description: description || city.description,
          location: location || city.location,
          images: imagePaths, // Replace old images with new ones if uploaded
          date: date ? new Date(date) : city.date, // Update date if provided, else keep old date
          isFeatured: isFeatured !== undefined ? isFeatured : city.isFeatured, // Use provided boolean or keep old value
        };

        // Perform the update
        const updatedCity = await City.findByIdAndUpdate(
            cityId,
            updatedFields,
            { new: true }
        );

        res.status(200).json(updatedCity);
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Delete a city
exports.deleteCity = async (req, res) => {
    try {
        const city = await City.findByIdAndDelete(req.params.id);
        if (!city) {
            return res.status(404).json({ error: 'City not found' });
        }
        res.status(200).json({ message: 'City deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};
