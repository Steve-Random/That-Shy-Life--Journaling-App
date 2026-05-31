package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/entries")
@CrossOrigin(origins = "http://localhost:57669")

public class JournalController {
    @Autowired
    private DatabaseManager databaseManager;

    @GetMapping
    public List<JournalEntry> getAllEntries(){
        return DatabaseManager.getAllEntries();
    }

    @PostMapping
    public void addEntry(@RequestBody JournalEntry entry){
        entry.setTimestamp(LocalDateTime.now());
        DatabaseManager.saveEntry(entry);
    }
}
