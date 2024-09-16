const mongoose = require('mongoose');

const tourPackageSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    duration: { type: String, required: true }, 
    location: { type: String, required: true }, 
    startDate: { type: Date, required: true }, // Changed to Date type
    endDate: { type: Date, required: true }, // Changed to Date type
    packageType: {
        type: String,
        enum: ['Family', 'Couple', 'Solo'],
        required: true
    },
    images: [{
        url: String, // Store Cloudinary image URLs
        public_id: String, // Store Cloudinary public ID
    }],
    availableSlots: { type: Number, default: 0 }, // Optional field to manage package capacity
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('TourPackage', tourPackageSchema);
