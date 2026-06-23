package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/entries")
@CrossOrigin(origins ={
        "http://localhost:8080",
        "http://localhost:60148",
        "https://that-shy-life-journaling-app.onrender.com",
        "https://that-shy-life-web.onrender.com/"})

public class JournalController {

    @Autowired
    private DatabaseManager databaseManager;

    @GetMapping
    public List<JournalEntry> getAllEntries(HttpServletRequest request){
        String userId = (String)request.getAttribute("userId");
        return databaseManager.getAllEntries(userId);
    }

    @PostMapping
    public JournalEntry addEntry(@RequestBody JournalEntry entry, HttpServletRequest request){
        String userId =(String)request.getAttribute("userId");
        entry.setTimestamp(LocalDateTime.now());
        entry.setUserId(userId);
        databaseManager.saveEntry(entry);
        return entry;
    }
}
