import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class JournalEntry {
    private String id;
    private LocalDateTime timestamp;
    private String content; //the actual journal text
    private String microEntry; //the one-wor or short phrase journal entry
    private int socialBattery;
    private boolean isAudioTranscript;
    private List<String> tags;

    public JournalEntry() {
        this.id = UUID.randomUUID().toString();
        this.timestamp = LocalDateTime.now();
        this.tags = new ArrayList<>();
    }

    //Helper method to ensure the tag starts with "#" for consistency, and avoid duplicates
    public void addTag(String tag) {
        if (!tag.startsWith("#")) {
            tag = "#" + tag;
        }
        if (!this.tags.contains(tag)) {
            this.tags.add(tag);
        }
    }
    //Setters
    public void setId(String id){
        this.id = id;
    }
    public void setContent(String content){
        this.content = content;
    }
    public void setSocialBattery(int socialBattery){
        this.socialBattery = socialBattery;
    }
    public void setMicroEntry(String microEntry){
        this.microEntry = microEntry;
    }
    public void setTags(List<String> tags){
        this.tags = tags;
    }
    public void setAudioTranscript (boolean isAudioTranscript){
        this.isAudioTranscript = isAudioTranscript;
    }


    //Getters
    public String getId() {
        return id;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public String getContent() {
        return content;
    }

    public int getSocialBattery() {
        return socialBattery;
    }

    public String getMicroEntry() {
        return microEntry;
    }

    public List<String> getTags() {
        return tags;
    }

    public boolean isAudioTranscript() {
        return isAudioTranscript;
    }
}