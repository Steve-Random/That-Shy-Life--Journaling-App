# That Shy Life - Full-Stack Journaling Application

A privacy-focused, cross-platform journaling application designed to provide a calm, distraction-free space
for quiet reflection. Features a custom "Social Battery" tracking framework that bridges the gap between text-based
entries and visual emotional energy analytics. 

## Live Deployments
* **Web Client:** [Live on Render] ( https://that-shy-life-web.onrender.com )
* **Android Client:** Active in Google Play Console (Closed Testing Track)
---
## Tech Stack & Production Architecture
### Frontend
* **Framework:** Flutter / Dart (Cross-platform Web & Android engine)
* **Analytics:** Firebase Analytics (Real-time user engagement & event tracking)
### Backend
* **Framework:** Java 17 / Spring Boot (RESTful API & secure endpoint routing)
* **Database:** PostgreSQL (Persistent relational storage hosted on Render)
* **DevOps & Deployment:** Docker (Multi-stage containerized build config)
---
## Key Features
* **Social Battery Integration:** A fluid UI slider dynamically maps user energy metrics to an analytical trend chart layout.
* **Intelligent Reminders:** Automated local notification system for daily reflection prompts.
* **Secure Storage:** Cryptographic data safety protocols ensuring completely private journal data ownership.
- **Minimalist UI/UX:** Intentionally designed to avoid the loud, high-pressure gamification loops of typical modern apps.
- **Tagging System:** Categorize reflections with custom tags for future filtering.
---
## System Architecture & Repository Structure
The project is structured as a decoupled monorepo containing both the enterprise Java backend service and the cross-platform Flutter user interface.
```text
src/main/java/com/thatshylife/    # Spring Boot REST API
 DatabaseManager.java             # JPA/Hibernate PostgreSQL data layer
 JournalController.java           # REST Endpoints for client interaction
 JournalEntry.java                # Database entity & relational model
 SecurityManager.java             # Cryptographic utilities
 Main.java                        # Application bootstrap

that_shy_life_ui/                 # Cross-platform Flutter Client
 lib/                            
  JournalFeedScreen.dart          # Main responsive timeline grid
  JournalService.dart             # HTTP service handling API handshakes
  ThatShyLifeApp.dart             # Application routing & core state
web/ & android/                   # Native target deployment wrappers 

Dockerfile                        # Multi-stage container instructions
pom.xml                           # Maven dependency configuration

```
## Security & Data Encryption
To guarantee complete user privacy, data undergoes Transparent Encryption before persistence:
1. Payload Encryption: Journal text is passed through the SecurityManager layer where it is encrypted using the Advanced Encryption Standard (AES) via the Java Cryptography Architecture (JCA).
2. Encoding: The resulting ciphertext is Base64 encoded to transmit and store alphanumeric strings safely.
3. Secure Persistence: The encoded payload is stored securely inside the cloud PostgreSQL database, rendering data unreadable to unauthorized parties or database administrators.
4. Decryption: Upon an authorized user request, the pipeline automatically decodes and decrypts the string back into plain text for rendering in the Flutter UI.

## Future Roadmap
* **Contextual AI Utilities:** Integrate a lightweight LLM API (Google Gemini, OpenAI) to power an optional, privacy-focused "AI Title Generator" that automatically suggests a short, meaningful title based on a user's written reflection to minimise writing friction.
* **Advanced Querying & Tag Filtering:** Implement a full-text search index and dedicated API endpoints to allow users to filter reflections by custom alphanumeric tags, specific date ranges, or keyword matches.
* **iOS Deployment:** Configure and build the Flutter client for Apple iOS devices, opening up the app to TestFlight testing.
* **Biometric Security Layer:** Integrate mobile biometric authentication (`local_auth`), including FaceID and fingerprint scanning, to add an extra layer of physical data privacy on launch.
* **Offline-First Synchronization:** Implement local client-side data caching (using Hive or SQLite) to allow uninterrupted offline journaling, featuring automated background synchronization with the PostgreSQL cloud database upon network reconnection.
