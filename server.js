const express = require("express");
const cors = require("cors");
const passwordRoutes = require("./routes/passwordRoutes");
require("dotenv").config();

const app = express();

app.use(express.json());
app.use(cors());

// Serve static files from the "public" directory
app.use(express.static('public'));

// API routes under /api
app.use("/api", passwordRoutes);

// Default route: serve the frontend index.html for root request
app.get("/", (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});