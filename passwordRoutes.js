// routes/passwordRoutes.js

const express = require("express");
const router = express.Router();

const { generatePassword, savePassword, getSavedPasswords } = require("../controllers/passwordController");

router.get("/generate-password", generatePassword);
router.post("/save-password", savePassword);
router.get("/saved-passwords", getSavedPasswords);

module.exports = router;