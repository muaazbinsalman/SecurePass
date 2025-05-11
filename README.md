
SecurePass

An advanced password management system built with PostgreSQL encryption, AI-based password generation, and a sleek UI.

Features:
- Secure encryption and decryption using PostgreSQL’s pgcrypto for Blowfish-based password security.
- AI-generated passwords based on user-provided context.
- Real-time password validation to ensure security compliance with strength analysis.
- Minimal and clean UI with essential functionalities.

Installation:
1. Clone the repository and navigate to the project folder.
2. Install dependencies using npm.
3. Set up environment variables in a .env file.
4. Initialize the PostgreSQL database.
5. Run the server using Node.js.

Usage Guide:
- Generate a suggested password using the provided button.
- Generate an AI-based password by entering the required context.
- Save passwords securely with encryption.
- Toggle password visibility with the eye button.

Tech Stack:
- Frontend: HTML, CSS, JavaScript
- Backend: Node.js, PostgreSQL
- Security: pgcrypto encryption

Future Improvements:
- Multi-Factor Authentication support.
- API integration for password validation.
- Mobile app development.

Contributors:
- Muaaz 
- Aayan Rashid 


Notes:
- node_modules should not be pushed to GitHub and should be added to .gitignore.
- If facing GitHub push issues, verify repository permissions and rules.
- Ensure PostgreSQL is correctly configured before running the server.
