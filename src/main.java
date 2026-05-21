public static void main(String[] args) {

    DatabaseManager.createNewTable();
    //Text entry example for "That Shy Life"
    JournalEntry firstEntry = new JournalEntry();
    firstEntry.setContent("Finally started the journaling app, feel good to build a private space");
    firstEntry.setSocialBattery(83);
    firstEntry.addTag("reflection");
    firstEntry.addTag("coding");

    DatabaseManager.saveEntry(firstEntry);

}
