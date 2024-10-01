const mongoose = require('mongoose');

// City Schema
const citySchema = new mongoose.Schema({
    name: { type: String, required: true, unique: true },
    description: { type: String, required: true },
    images: [{ type: String }], // Array of image URLs
    location: { type: String, required: true },
    date: { type: Date },
    commentCount: { type: Number },
    isFeatured: { type: Boolean, default: false },
    // Adding reference to tour packages
    tourPackages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'TourPackage' }]
}, {
    timestamps: true
});

const City = mongoose.model('City', citySchema);
module.exports = City;
