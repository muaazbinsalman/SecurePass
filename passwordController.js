// controllers/passwordController.js

const pool = require("../db");
const zxcvbn = require("zxcvbn");

// Use the SECRET_KEY from your .env file (or default to 'LadisWashroom')
const newSecretKey = process.env.SECRET_KEY || 'LadisWashroom';

/**
 * Basic password generator using a simple random approach.
 */
const generatePassword = async (req, res) => {
  try {
    const length = req.query.length || 12;
    const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
    let password = "";
    for (let i = 0; i < length; i++) {
      password += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    const strengthResult = zxcvbn(password);

    res.json({
      password,
      strength: strengthResult.score,
      feedback: strengthResult.feedback,
    });
  } catch (error) {
    console.error("Error generating password:", error.message);
    res.status(500).json({ error: "Server error" });
  }
};

/**
 * Save a password using new encryption.
 * This query uses pgcrypto's encrypt() to encrypt the password.
 */
const savePassword = async (req, res) => {
  try {
    const { user_identifier, password } = req.body;
    if (!password) return res.status(400).json({ message: "Password required" });

    const strengthResult = zxcvbn(password);

    const query = `
      INSERT INTO secure_passwords (user_identifier, password, strength, created_at)
      VALUES (
        $1,
        encrypt(convert_to($2, 'utf8'), convert_to($3, 'utf8'), 'bf'),
        $4,
        NOW()
      )
      RETURNING *;
    `;
    const values = [user_identifier, password, newSecretKey, strengthResult.score];
    const result = await pool.query(query, values);

    res.json({ message: "Password saved successfully!", data: result.rows[0] });
  } catch (error) {
    console.error("Error saving password:", error.message);
    res.status(500).json({ error: "Server error while saving password" });
  }
};

/**
 * Retrieve and decrypt saved passwords.
 * It uses decrypt() together with convert_from() so that you get back plaintext.
 */
const getSavedPasswords = async (req, res) => {
  try {
    const query = `
      SELECT 
        user_identifier, 
        convert_from(decrypt(password, convert_to($1, 'utf8'), 'bf'), 'utf8') AS decrypted_password,
        strength,
        created_at
      FROM secure_passwords;
    `;
    const result = await pool.query(query, [newSecretKey]);
    res.json({ saved_passwords: result.rows });
  } catch (error) {
    console.error("Error retrieving passwords:", error.message);
    res.status(500).json({ error: "Server error while fetching passwords" });
  }
};

module.exports = { generatePassword, savePassword, getSavedPasswords };