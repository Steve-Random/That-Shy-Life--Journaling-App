public static void main(String[] args) {

    /*DatabaseManager.createNewTable();
    //Text entry example for "That Shy Life"
    JournalEntry firstEntry = new JournalEntry();
    firstEntry.setContent("Finally started the journaling app, feel good to build a private space");
    firstEntry.setSocialBattery(83);
    firstEntry.addTag("reflection");
    firstEntry.addTag("coding");

    DatabaseManager.saveEntry(firstEntry);*/

    List<JournalEntry> history = DatabaseManager.getAllEntries();
    System.out.println("--- THE VAULT: ALL ENTRIES ---");
    for( JournalEntry entry: history){
        System.out.println("ID: " + entry.getId());
        System.out.println("Content: " + entry.getContent());
        System.out.println("Social Battery: " + entry.getSocialBattery());
        System.out.println("Tags: " + entry.getTags());
        System.out.println("--------------------------------------------- ");
        System.out.println();
    }

}
