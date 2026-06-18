package com.thatshylife;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
@Component
public class DatabaseManager {

    @PostConstruct
    public void init(){
        createNewTable();
    }

    @Value("${DB_URL}")
    private String dbUrl;

    @Value("${DB_USER}")
    private String dbUser;

    @Value("${DB_PASSWORD}")
    private String dbPassword;

    public Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(dbUrl,dbUser,dbPassword);
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
        }
        return conn;
    }

    public void createNewTable() {
        String sql = "CREATE TABLE IF NOT EXISTS entries ("
                + " id TEXT PRIMARY KEY,"
                + " timestamp TEXT NOT NULL,"
                + " content TEXT,"
                + " microEntry TEXT,"
                + " socialBattery INTEGER,"
                + " isAudioTranscript INTEGER,"
                + " tags TEXT"
                + ");";
        try (Connection conn = connect();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table 'entries' is ready.");
        } catch (SQLException e) {
            System.out.println("Table creation failed: " + e.getMessage());
        }
    }


    public void saveEntry(JournalEntry entry) {
        String sql = "INSERT INTO entries(id, timestamp, content, microEntry, socialBattery, isAudioTranscript, tags) VALUES(?,?,?,?,?,?,?)";

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

            pstmt.executeUpdate();
            System.out.println("Entry saved to the Vault.");
        } catch (Exception e) {
            System.out.print("Save failed: " + e.getMessage());
        }
    }

    public  List<JournalEntry> getAllEntries() {
        List<JournalEntry> entries = new ArrayList<>();
        String sql = "SELECT * FROM entries";

        try (Connection conn = connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

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
