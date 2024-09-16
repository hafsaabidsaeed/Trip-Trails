const express = require('express');
const connectToDb = require('./configurations/db');
require('dotenv').config();
const app = express();
const cityRoutes = require('./routes/placesRoutes');
const tourPackageRoutes = require('./routes/tourPackageRoutes.js');
const cors = require('cors');
const path = require('path'); // Import path module
const upload = require('./configurations/multer'); // Import the multer configuration
const ImageModel = require('./models/tourPackageModel'); // Make sure you have your ImageModel defined properly

app.post('/upload', (req, res) => {
  upload(req, res, async function (err) {
    if (err) {
      return res.status(400).send(`Upload Error: ${err.message}`);
    }

    if (!req.file) {
      return res.status(400).send('No file uploaded');
    }

    // Save the image URL and public ID from Cloudinary in MongoDB
    const newImage = new ImageModel({
      url: req.file.path,       // Cloudinary image URL (path contains secure_url)
      public_id: req.file.filename,  // Cloudinary public ID
    });

    try {
      await newImage.save();
      res.status(200).send('Image uploaded to Cloudinary and saved to MongoDB');
    } catch (error) {
      res.status(500).send(`Error saving image to MongoDB: ${error.message}`);
    }
  });
});

// Enable CORS for all routes
app.use(cors());

// Connect Database
connectToDb(); 

// Init Middleware
app.use(express.json());

// Serve static files from the uploads directory (for local files, not Cloudinary)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Define Routes
app.use('/api/auth', require('./routes/userRoutes'));
app.use('/api/cities', cityRoutes);
app.use('/api/tour-packages', tourPackageRoutes);

const PORT = process.env.PORT || 5009;
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
