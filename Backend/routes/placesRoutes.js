// routes/places.js
const express = require('express');
const router = express.Router();
const { getPlacesByCity } = require('../services/googlePlacesServices');

// GET /api/places?city=CityName
router.get('/', async (req, res) => {
  const cityName = req.query.city;

  if (!cityName) {
    return res.status(400).json({ error: 'City name is required' });
  }

  try {
    const places = await getPlacesByCity(cityName);
    res.json({ city: cityName, places });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch places' });
  }
});

module.exports = router;


