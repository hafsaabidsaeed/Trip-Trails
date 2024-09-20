const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('cloudinary').v2;
const path = require('path');

// Configure Cloudinary with your credentials
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
  secure: true,
});

// Set Cloudinary storage engine for multer
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'trip_trails', // Folder in your Cloudinary account
    format: async (req, file) => {
      const fileExtension = path.extname(file.originalname).toLowerCase();
      return fileExtension === '.png' ? 'png' : 'jpg'; // Automatically set image format
    },
    public_id: (req, file) => 'image-' + Date.now(), // Image filename on Cloudinary
  },
});

// Initialize upload for multiple files
const upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 5 }, // Limit image size to 5MB
  fileFilter: function (req, file, cb) {
    checkFileType(file, cb);
  },
}).array('images', 10); // Allow up to 10 images

// Check file type
function checkFileType(file, cb) {
  const filetypes = /jpeg|jpg|png|gif/; // Allowed extensions
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Images Only!');
  }
}

module.exports = upload;
