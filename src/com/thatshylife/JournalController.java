package com.thatshylife;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/entries")
@CrossOrigin(origins = "*")

public class JournalController {
    @GetMapping
    public List<JournalEntry> getAllEntries(){
        return DatabaseManager.getAllEntries();
    }

    @PostMapping
    public String addEntry(@RequestBody JournalEntry entry){
        DatabaseManager.saveEntry(entry);
        return "Entry saved to the Vault!";
    }
}
