const mongoose = require('mongoose');
require('dotenv').config();

module.exports = async function connectToDb() {
    try {
        console.log('MONGO_URI:', process.env.MONGO_URI);  // Debugging line

        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('Could not connect to MongoDB', error);
    }
}

