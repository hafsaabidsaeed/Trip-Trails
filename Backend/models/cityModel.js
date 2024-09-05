const mongoose = require('mongoose');

// Create a schema  for the city
const citySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true,
    },
    description: {
        type: String,
        required: true,
    },
    image: {
        type: String, // This will store the path or URL to the image
      },
}, {
    timestamps: true
});

// Create a model from the schema
const City = mongoose.model('City', citySchema);

// Export the model
module.exports = City;
