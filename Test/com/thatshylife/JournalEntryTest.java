package com.thatshylife;

import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for {@link JournalEntry}. Most of this class is plain setters and getters
 * with no logic, so tests focus on the two places that do something non-trivial:
 * the no-arg constructor's auto-generated fields, and {@link JournalEntry#addTag(String)}'s
 * normalization/dedup behavior.
 */
class JournalEntryTest {

    @Test
    public void constructor_generatesNonNull(){
        JournalEntry entry = new JournalEntry();
        assertNotNull(entry.getId());
    }

    @Test
    public void constructor_generatesUniqueIdsAcrossInstances(){
        JournalEntry first = new JournalEntry();
        JournalEntry second = new JournalEntry();

        assertNotEquals(first.getId(), second.getId());
    }

    @Test
    public void constructor_setsTimestampToApproximatelyNow(){
        LocalDateTime before = LocalDateTime.now();
        JournalEntry entry = new JournalEntry();
        LocalDateTime after = LocalDateTime.now();

        assertFalse(entry.getTimestamp().isBefore(before.minus(1, ChronoUnit.SECONDS)));
        assertFalse(entry.getTimestamp().isAfter(after.plus(1, ChronoUnit.SECONDS)));
    }

    @Test
    public void constructor_initializesEmptyTagsList(){
        JournalEntry entry = new JournalEntry();

        assertNotNull(entry.getTags());
        assertTrue(entry.getTags().isEmpty());
    }

    @Test
    public void addTag_withoutLeadingHash_getsHashPrepended(){
        JournalEntry entry = new JournalEntry();
        entry.addTag("shy");
        assertEquals(List.of("#shy"), entry.getTags());
    }

    @Test
    public void addTag_withLeadingHash_addedUnchanged(){
        JournalEntry entry = new JournalEntry();
        entry.addTag("#shy");
        assertEquals(List.of("#shy"), entry.getTags());
    }

    @Test
    public void addTag_duplicateTagWithHash_notAddedTwice(){
        JournalEntry entry = new JournalEntry();
        entry.addTag("#shy");
        entry.addTag("#shy");
        assertEquals(1, entry.getTags().size());
    }

    @Test
    public void addTag_sameTagWithAndWithoutHash_treatedAsDuplicate(){
        JournalEntry entry = new JournalEntry();
        entry.addTag("shy");
        entry.addTag("#shy");
        assertEquals(1, entry.getTags().size());
    }

    @Test
    public void addTag_differentiateTags_bothAdded(){
        JournalEntry entry = new JournalEntry();
        entry.addTag("shy");
        entry.addTag("battery");
        assertEquals(List.of("#shy", "#battery"), entry.getTags());
    }

    @Test
    public void settersAndGetters_roundTripCorrectly(){
        JournalEntry entry = new JournalEntry();
        LocalDateTime timestamp = LocalDateTime.of(2026, 1, 1, 12, 0);

        entry.setUserId("user-1");
        entry.setId("custom-id");
        entry.setTimestamp(timestamp);
        entry.setContent("Today was a quiet day.");
        entry.setMicroEntry("Quiet");
        entry.setSocialBattery(45);
        entry.setAudioTranscript(true);
        entry.setTags(List.of("#quiet"));

        assertEquals("user-1", entry.getUserId());
        assertEquals("custom-id", entry.getId());
        assertEquals(timestamp, entry.getTimestamp());
        assertEquals("Today was a quiet day.", entry.getContent());
        assertEquals("Quiet", entry.getMicroEntry());
        assertEquals(45, entry.getSocialBattery());
        assertTrue(entry.isAudioTranscript());
        assertEquals(List.of("#quiet"), entry.getTags());
    }
}