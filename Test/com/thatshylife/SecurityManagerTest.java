package com.thatshylife;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SecurityManagerTest {

    @BeforeEach
    void setUp() {
        //16-character test key
        SecurityManager manager = new SecurityManager();
        manager.setSecretKey("12345jknonmono67890abcdef");
    }

    @Test
    void testEncryptReturnsNonNullValue() {
        String encrypted = SecurityManager.encrypt("Hello World");
        assertNotNull(encrypted);
        assertNotEquals("Hello World", encrypted);
    }

    @Test
    void testDecryptRestoresOriginalValue() {
        String original = "Hello World";
        String encrypted = SecurityManager.encrypt(original);
        String decrypted = SecurityManager.decrypt(encrypted);
        assertEquals("Hello World", decrypted);
    }

    @Test
    void testEncryptEmptyNullFallsBackToPlainText() {
        String result = SecurityManager.encrypt(null);
        assertNull(result);
    }

}