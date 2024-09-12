const mongoose = require('mongoose');

const tourPackageSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    duration: { type: String, required: true }, 
    location: { type: String, required: true }, 
    packageType: {
        type: String,
        enum: ['Family', 'Couple', 'Solo'],
        required: true
    },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('TourPackage', tourPackageSchema);