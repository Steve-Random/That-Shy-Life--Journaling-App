# That-Shy-Life--Journaling-App

A privacy-focused Journaling application designed for introverts  to reflect 
on their daily experiences, track social energy, and maintain a secure personal space.

## Features
- **Secure Persistence:** Uses SQLite for local data storage.
- **AES-128 Encryption:** All journal content is encrypted before storage using Advanced
Encryption Standard (AES) to ensure user privacy.
- **Social battery:** Quantitative tracking of energy levels (0-100%) integrated with
daily entries.
- **Tagging System:** Categorize reflections with custom tags for future filtering.
- **Clean Architecture:** Separated into clear UI, Security, and Database layers.

## Tech Stack
- **Language:** Java 17+
- **Database:** SQLite (via JDBC)
- **Security:** Java Cryptography Architecture (JCA)
- **Serialization:** Jackson (JSON processing for tags)

## Project Structure
- `com.thatshylife.Main.java`: The entry point that initializes the UI.
- `com.thatshylife.MenuHandler.java`: Handles user interaction and console-based navigation.
- `com.thatshylife.JournalEntry.java`: The core data model for reflections.
- `com.thatshylife.DatabaseManager.java`: Manage SQL queries and database connection lifecycle.
- `com.thatshylife.SecurityManager.java`: Implementation of AES encryption/decryption logic.

## Security Implementation
Tha app implements "Transparent Encryption." When a user saves an entry:
1. The content is passed to the `com.thatshylife.SecurityManager`.
2. It is encrypted a using a 16-byte secret key and the AES algorithm.
3. The resulting ciphertext is Base64 encoded and stored in the SQLite database.
4. Upon retrieval, the process is reversed to display the plain text.

## Future Roadmap
- **Full-Stack Migration:** Transitioning to a Spring Boot API with a Flutter front end.
- **Insights:** data visualization for social battery trends.
- **Advanced Search:** Filtering reflections by date ranges and specific categories.