const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const cityRoutes = require('./routes/placesRoutes');
const tourPackageRoutes = require('./routes/tourPackageRoutes.js');
const cors = require('cors');
const path = require('path'); // Import path module
const upload = require('./configurations/multer'); // Import the multer configuration

app.post('/upload', upload, async (req, res) => {
    if (!req.file) {
      return res.status(400).send('No file uploaded');
    }
  
    // Save the image URL in MongoDB
    const newImage = new ImageModel({
      url: req.file.path, // Cloudinary image URL
      public_id: req.file.filename, // Cloudinary public ID
    });
  
    try {
      await newImage.save();
      res.status(200).send('Image uploaded to Cloudinary and saved to MongoDB');
    } catch (error) {
      res.status(500).send('Error saving image to MongoDB');
    }
  });

  
// Enable CORS for all routes
app.use(cors());


// Connect Database
connectToDb(); 


// Init Middleware
app.use(express.json());

// Serve static files from the uploads directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);
app.use('/api/tour-packages', tourPackageRoutes);

const PORT = process.env.PORT || 5009;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
