import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class JournalEntryTest {
    private JournalEntry entry;

    @BeforeEach
    void setUp() {
        entry = new JournalEntry();
    }

    @Test
    public void testIdUniqueness(){
        JournalEntry secondEntry = new JournalEntry();
        assertNotNull(entry.getId());
        assertNotNull(secondEntry.getId());
        assertNotEquals(entry.getId(),secondEntry.getId());
    }

    @Test
    public void testAddTagFormatting(){
        entry.addTag("school");
        entry.addTag("#reflection");
        List<String> tags = entry.getTags();

        assertTrue(tags.contains("#school"),"Should automatically add '#' at the prefix if missing.");
        assertTrue(tags.contains("#reflection"), "Should automatically keep '#' if already present.");
        assertEquals(2,tags.size(), "Should have exactly 2 tags");
    }

    @Test
    public void testNoDuplicateTags(){
        entry.addTag("recharge");
        entry.addTag("#recharge");
        entry.addTag("recharge");

        List<String> tags = entry.getTags();
        assertEquals(1,tags.size());
        assertEquals("#recharge", tags.getFirst());
    }
}