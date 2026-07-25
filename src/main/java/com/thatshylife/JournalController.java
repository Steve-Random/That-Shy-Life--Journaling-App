package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

/**
 * REST controller exposing CRUD-style endpoints for journal entries
 * under {@code /api/entries}.
 * <p>
 * The authenticated user's ID is not passed explicitly by callers;
 * it is read from the {@code "userId"} request attribute, which is
 * populated upstream by {@link AuthFilter} after validating the JWT.
 * </p>
 */
@RestController
@RequestMapping("/api/entries")
@CrossOrigin(origins ={
        "http://localhost:8080",
        "http://localhost:60148",
        "https://that-shy-life-journaling-app.onrender.com",
        "https://that-shy-life-web.onrender.com",
        "https://that-shy-life-journaling-app-staging.onrender.com",
        "https://that-shy-life-web-staging.onrender.com"
})

public class JournalController {

    @Autowired
    private DatabaseManager databaseManager;

    /**
     * Returns all journal entries belonging to the authenticated user.
     */
    @GetMapping
    public List<JournalEntry> getAllEntries(HttpServletRequest request){
        String userId = (String)request.getAttribute("userId");
        return databaseManager.getAllEntries(userId);
    }

    /**
     * Creates a new journal entry for the authenticated user, stamping it
     * with the current server time and the caller's user ID before saving.
     *
     * @param entry the entry payload from the request body; its timestamp
     *     and user ID are overwritten regardless of what's sent
     */
    @PostMapping
    public JournalEntry addEntry(@RequestBody JournalEntry entry, HttpServletRequest request){
        String userId =(String)request.getAttribute("userId");
        entry.setTimestamp(LocalDateTime.now());
        entry.setUserId(userId);
        databaseManager.saveEntry(entry);
        return entry;
    }
}
