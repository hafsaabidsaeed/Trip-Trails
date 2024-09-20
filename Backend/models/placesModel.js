const mongoose = require('mongoose');

// Create a schema for the city
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
    images: [{
        type: String, // This will store the path or URL to the image
    }],
    location: {
        type: String, // Store location as a string (e.g., city name or coordinates)
        required: true,
    },
    date: {
        type: Date, // Date when the city was added
    },
    commentCount: {
        type: Number, 
    },
    isFeatured: {
        type: Boolean, // Whether the city is featured or not
        default: false, // Default to not fea tured
    },
}, {
    timestamps: true // Automatically add createdAt and updatedAt timestamps
});

// Create a model from the schema
const City = mongoose.model('City', citySchema);

// Export the model
module.exports = City;
