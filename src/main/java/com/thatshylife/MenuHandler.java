package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Scanner;
@Component
public class MenuHandler {
    @Autowired
    private DatabaseManager databaseManager;
    private final Scanner scanner = new Scanner(System.in);
    private boolean running = true;


    public void start() {
        System.out.println("Welcome to the That Shy Life Vault.");
        while (running) {
            displayMenu();
            handleChoice();
        }
        scanner.close();
    }

    private void displayMenu() {
        System.out.println("\n---- MAIN MENU ---");
        System.out.println("1. Write a New Entry");
        System.out.println("2. View All Entries");
        System.out.println("3. Exit");
        System.out.println("Choose:  ");
    }

    private void handleChoice() {
        int choice = Integer.parseInt(scanner.nextLine());
        switch (choice) {
            case 1:
                addNewEntry();
            case 2:
                showHistory();
            case 3: {
                System.out.println("Closing Vault...");
                running = false;
            }
            default:
                System.out.println("Invalid option");
        }
    }

    private void addNewEntry() {
        System.out.println("What's on your mind? ");
        String content = scanner.nextLine();
        System.out.println("Social Battery (0-100): ");
        int socialBattery = Integer.parseInt(scanner.nextLine());

        JournalEntry entry = new JournalEntry();
        entry.setContent(content);
        entry.setSocialBattery(socialBattery);

        databaseManager.saveEntry(entry);
    }

    private void showHistory() {
    /*    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy | hh:mm a");
        List<JournalEntry> history = databaseManager.getAllEntries();
        System.out.println("--- THE VAULT: ALL ENTRIES ---");
        for (JournalEntry entry : history) {
            System.out.println("ID: " + entry.getId());
            String formattedDate = entry.getTimestamp().format(formatter);
            System.out.println("Date: " + formattedDate);
            if (entry.getMicroEntry() != null) {
                System.out.println("Micro Entry: " + entry.getMicroEntry());
            }
            System.out.println("Content: " + entry.getContent());
            System.out.println("Social Battery: " + entry.getSocialBattery());
            System.out.println("Tags: " + entry.getTags());
            System.out.println("--------------------------------------------- ");
            System.out.println();*/
      //  }
    }
}
