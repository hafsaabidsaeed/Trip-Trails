const City = require('../models/placesModel');

// Create a new city
exports.createCity = async (req, res) => {
    try {
      const { name, description, location, date, isFeatured } = req.body;

      // Check if image was uploaded
      let imagePath = req.file ? `/uploads/${req.file.filename}` : null;

      const newCity = new City({
        name,
        description,
        location,
        image: imagePath,           // Save the image path
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

// Get a single city by ID
exports.getCityById = async (req, res) => {
    try {
        const city = await City.findById(req.params.id);
        if (!city) {
            return res.status(404).json({ error: 'City not found' });
        }
        res.status(200).json(city);
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};

// Update city
exports.updateCity = async (req, res) => {
    try {
        const cityId = req.params.id;
        const { name, description, location, date, isFeatured } = req.body;

        // If image is uploaded, update it
        let imagePath = req.file ? `/uploads/${req.file.filename}` : null;

        const updatedFields = {
          name,
          description,
          location,
          date: date ? new Date(date) : null, // Update date if provided
          isFeatured: isFeatured || false,
        };

        // Only update the image if a new one is provided
        if (imagePath) {
          updatedFields.image = imagePath;
        }

        const updatedCity = await City.findByIdAndUpdate(
            cityId,
            updatedFields,
            { new: true }
        );

        if (!updatedCity) {
            return res.status(404).json({ message: 'City not found' });
        }

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
