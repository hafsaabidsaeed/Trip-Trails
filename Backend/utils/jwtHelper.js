//  const jwt = require('jsonwebtoken');

// const SECRET_KEY = "secret";  // Store this securely!
// const generateToken = (user) => {
//     const expiresIn = 1 * 60; // 1 minutes in seconds

//     return jwt.sign({ id: user._id, email: user.email }, SECRET_KEY, {
//         expiresIn
//     });
// };

// const verifyToken = (token) => {
//     return jwt.verify(token, SECRET_KEY);
// };
// module.exports = { generateToken, verifyToken };