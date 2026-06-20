package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/entries")
@CrossOrigin(origins ={"http://localhost:8080",
"http://localhost:60148","https://that-shy-life-journaling-app.onrender.com","https://that-shy-life-web.onrender.com/"})

public class JournalController {
    @Autowired
    private DatabaseManager databaseManager;

    @GetMapping
    public List<JournalEntry> getAllEntries(){
        return databaseManager.getAllEntries();
    }

    @PostMapping
    public void addEntry(@RequestBody JournalEntry entry){
        entry.setTimestamp(LocalDateTime.now());
        databaseManager.saveEntry(entry);
    }
}
