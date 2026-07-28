package com.thatshylife;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Manages raw JDBC access to the application PostgreSQL database,
 * including schema setup and CRUD operations for {@link User} and
 * {@link JournalEntry} records.
 * <p>
 * Journal entry content and micro-entries are encrypted via
 * {@link SecurityManager} before being persisted and decrypted on read.
 */
@Component
public class DatabaseManager {

    // for testing  [
/** No-arg constructor required for testing. */
    public DatabaseManager(){}

    /**
     * Constructs a manager with explicit connection credentials, by passing
     * the {@code @value}-injected fields. Intended for tests
     */
    public DatabaseManager(String dbUrl, String dbUser, String dbPassword) {
        this.dbUrl = dbUrl;
        this.dbUser = dbUser;
        this.dbPassword = dbPassword;
    }

    //   ] for testing

    /**
     * Creates the {@code users}and {@code entries} tables on startup if
     * they don't already exist.
     */
    @PostConstruct
    public void init(){
        createUsersTable();
        createNewTable();
    }

    @Value("${DB_URL}")
    private String dbUrl;

    @Value("${DB_USER}")
    private String dbUser;

    @Value("${DB_PASSWORD}")
    private String dbPassword;

    /**
     * Opens a new database connection using the injected credentials
     *
     * @return an open {@link Connection}, or {@code null} if the connection
     *    attempt failed (logged to stdout rather than thrown)
     */
    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(dbUrl,dbUser,dbPassword);
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
        }
        return conn;
    }

    //Users......

    public void createUsersTable(){
        String sql = "CREATE TABLE IF NOT EXISTS users ("
                + " id TEXT PRIMARY KEY,"
                + " email TEXT NOT NULL UNIQUE,"
                + " password TEXT NOT NULL,"
                + " createdAt TEXT NOT NULL"
                + ");";

        try(Connection conn = connect();
         Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table 'users' is ready");
        }catch (SQLException e){
            System.out.println("Users table creation failed." + e.getMessage());
        }
    }

    public void saveUser(User user){
        String sql = "INSERT INTO users (id, email, password, createdAt) VALUES (?,?,?,?)";

        try(Connection conn = connect();
           PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getCreatedAt().toString());
            pstmt.executeUpdate();
            System.out.println("User saved.");
        } catch (SQLException e){
            System.out.println("Save user failed" + e.getMessage());
        }
    }

    /**
     * Looks up a user by email.
     *
     * @return the matching {@link User}, or {@code null} if no user with
     *     this email exists or the query fails
     */
    public com.thatshylife.User findUserByEmail(String email){
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = connect();
         PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()){
                com.thatshylife.User user = new com.thatshylife.User();
                user.setId(rs.getString("id"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setCreatedAt(LocalDateTime.parse(rs.getString("createdAt")));
                return user;
            }
        }catch (SQLException e){
            System.out.println("Find user failed" + e.getMessage());
        }
        return null;
    }

    //Entries.....

    public void createNewTable() {
        String sql = "CREATE TABLE IF NOT EXISTS entries ("
                + " id TEXT PRIMARY KEY,"
                + " timestamp TEXT NOT NULL,"
                + " content TEXT,"
                + " microEntry TEXT,"
                + " socialBattery INTEGER,"
                + " isAudioTranscript INTEGER,"
                + " tags TEXT,"
                + " userId TEXT REFERENCES users(id)"
                + ");";
        try (Connection conn = connect();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table 'entries' is ready.");
        } catch (SQLException e) {
            System.out.println("Table creation failed: " + e.getMessage());
        }
    }

    /**
     * Persists a journal entry, encrypting its content and micro-entry
     * text via {@link SecurityManager} before storage, and serializing
     * its tags to JSON
     */
    public void saveEntry(JournalEntry entry) {
        String sql = "INSERT INTO entries(id, timestamp, content, microEntry, socialBattery, isAudioTranscript, tags, userId) VALUES(?,?,?,?,?,?,?,?)";

        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ObjectMapper mapper = new ObjectMapper();
            String tagsJson = mapper.writeValueAsString(entry.getTags());

            pstmt.setString(1, entry.getId());
            pstmt.setString(2, entry.getTimestamp().toString());
            String encryptedContent = SecurityManager.encrypt(entry.getContent()); //encrypting
            pstmt.setString(3, encryptedContent);
            String encryptedMicroEntry = SecurityManager.encrypt(entry.getMicroEntry()); //encrypting
            pstmt.setString(4, encryptedMicroEntry);
            pstmt.setInt(5, entry.getSocialBattery());
            pstmt.setInt(6, entry.isAudioTranscript() ? 1 : 0);
            pstmt.setString(7, tagsJson);
            pstmt.setString(8, entry.getUserId());

            pstmt.executeUpdate();
            System.out.println("Entry saved to the Vault.");
        } catch (Exception e) {
            System.out.print("Save failed: " + e.getMessage());
        }
    }

    /**
     * Retrieves all journal entries belonging to a user, decrypting content
     * and micro-entry text and deserializing tags back from JSON.
     *
     * @return the user's entries, or an empty list if none exist or the
     *    query fails
     */
    public  List<JournalEntry> getAllEntries(String userId) {
        List<JournalEntry> entries = new ArrayList<>();
        String sql = "SELECT * FROM entries WHERE userId = ?";

        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(sql)){
             pstmt.setString(1, userId);
             ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                JournalEntry entry = new JournalEntry();
                entry.setId(rs.getString("id"));
                //timestamp parsing
                String timestampStr = rs.getString("timestamp");
                if(timestampStr != null){
                    entry.setTimestamp(LocalDateTime.parse(timestampStr));
                }
                entry.setContent(SecurityManager.decrypt(rs.getString("content"))); //Decrypting
                entry.setMicroEntry(SecurityManager.decrypt(rs.getString("microEntry"))); //Decrypting
                entry.setSocialBattery(rs.getInt("socialBattery"));
                //handling boolean conversion (1 = true, 0 = false)
                entry.setAudioTranscript(rs.getInt("isAudioTranscript") == 1);
                //tags parsing
                String tagsJson = rs.getString("tags");
                if ((tagsJson != null) && (!tagsJson.isEmpty())){
                    try {
                        ObjectMapper mapper = new ObjectMapper();
                        List<String> tags = mapper.readValue(tagsJson,mapper.getTypeFactory().constructCollectionType(List.class, String.class));
                        entry.setTags(tags);
                    } catch (Exception e){
                        System.out.println("Error parsing tags: " + e.getMessage());
                    }
                }
                entries.add(entry);
            }

        } catch (SQLException e) {
            System.out.println("Retrieval failed: " + e.getMessage());
        }
        return entries;
    }

}
