const mongoose = require('mongoose');


// Tour Package Schema
const tourPackageSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    duration: { type: String, required: true },
    location: { type: String, required: true },
    startDate: { type: String, required: true },
    endDate: { type: String, required: true },
    packageType: {
        type: String,
        enum: ['Family', 'Couple', 'Solo'],
        required: true
    },
    images: [{ type: String }],  // Array to store multiple image paths
    createdAt: { type: Date, default: Date.now },
    // Adding reference to city
    city: { type: mongoose.Schema.Types.ObjectId, ref: 'City', required: true }
});

// Export the model
module.exports = mongoose.model('TourPackage', tourPackageSchema);


