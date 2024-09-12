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
    image: {
        type: String, // This will store the path or URL to the image
    },
    location: {
        type: String, // Store location as a string (e.g., city name or coordinates)
        required: true,
    },
    date: {
        type: Date, // Store the date, can be used for tracking when the city was added
        default: Date.now, // Default to current date
    },
    commentCount: {
        type: Number, // Count of comments associated with the city
        default: 0, // Default to 0
    },
    isFeatured: {
        type: Boolean, // Whether the city is featured or not
        default: false, // Default to not featured
    },
}, {
    timestamps: true // Automatically add createdAt and updatedAt timestamps
});

// Create a model from the schema
const City = mongoose.model('City', citySchema);

// Export the model
module.exports = City;
