import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DatabaseManager {
    private static final String DB_URL = "jdbc:sqlite:journal.db";

    public static Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL);
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
        }
        return conn;
    }

    public static void createNewTable() {
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

    public static void saveEntry(JournalEntry entry) {
        String sql = "INSERT INTO entries(id, timestamp, content, microEntry, socialBattery, isAudioTranscript, tags) VALUES(?,?,?,?,?,?,?)";

        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            ObjectMapper mapper = new ObjectMapper();
            String tagsJson = mapper.writeValueAsString(entry.getTags());

            pstmt.setString(1, entry.getId());
            pstmt.setString(2, entry.getTimestamp().toString());
            pstmt.setString(3, entry.getContent());
            pstmt.setString(4, entry.getMicroEntry());
            pstmt.setInt(5, entry.getSocialBattery());
            pstmt.setInt(6, entry.isAudioTranscript() ? 1 : 0);
            pstmt.setString(7, tagsJson);

            pstmt.executeUpdate();
            System.out.println("Entry saved to the Vault.");
        } catch (Exception e) {
            System.out.print("Save failed: " + e.getMessage());
        }
    }

    public static List<JournalEntry> getAllEntries() {
        List<JournalEntry> entries = new ArrayList<>();
        String sql = "SELECT * FROM entries";

        try (Connection conn = connect();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                JournalEntry entry = new JournalEntry();
                entry.setId(rs.getString("id"));
                //Just grabbing the basic fields, for timestamp, we'll parse it later since it was saved as a String
                entry.setContent(rs.getString("content"));
                entry.setMicroEntry(rs.getString("microEntry"));
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
