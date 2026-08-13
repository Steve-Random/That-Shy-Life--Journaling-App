package com.thatshylife;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for {@link SecurityManager}. Like {@link JwtUtil}, {@code secretKey}
 * is a static field set via an instance method (normally Spring-injected via
 * {@code @value}), so each test initializes it manually first.
 * <p>
 *     AES-128 requires a key of exactly 16 bytes - unlike JwtUtilTest's HS256
 *     key, this can't just be "long enough"; it must be exactly 16 bytes or
 *     {@code SecretKeySpec} construction fails.
 * </p>
 */

class SecurityManagerTest {

    private static final String TEST_SECRET = "sixteenByteKey!!";   //16-character test key

    @BeforeEach
    void setUp() {
        new SecurityManager().setSecretKey(TEST_SECRET);
    }

    @Test
    void encrypt_themeDecrypt_returnsOriginalValue() {
        String original = "This is a private journal entry.";
        String encrypted = SecurityManager.encrypt(original);

        assertEquals(original, SecurityManager.decrypt(encrypted));
    }

    @Test
    void encrypt_produceCiphertextDifferentFromPlaintext() {
        String original = "Sensitive content";
        String encrypted = SecurityManager.encrypt(original);

        assertNotEquals(original, encrypted);
    }

    @Test
    void encrypt_sameValueTwice_produceSameCiphertext() {           //Known ECB limitation, migrating to AES/CBC or AES/GCM will
        String original = "repeated content";                       // lead to failure of tests thus requiring test modification, it is not a bug.
        String encryptedFirst = SecurityManager.encrypt(original);
        String encryptedSecond = SecurityManager.encrypt(original);

        assertEquals(encryptedFirst, encryptedSecond);
    }

    @Test
    void encrypt_emptyString_roundTrips() {
        String encrypted = SecurityManager.encrypt("");

        assertEquals("", SecurityManager.decrypt(encrypted));
    }

    @Test
    void decrypt_withGarbageInput_returnsInputUnchanged() {
        String garbage = "not valid base64 !!!@@@";

        assertEquals(garbage, SecurityManager.decrypt(garbage));
    }

    @Test
    void decrypt_withPlaintextNeverEncrypted_returnsInputUnchanged() {
        String plaintext = "this was never encrypted";

        assertEquals(plaintext, SecurityManager.decrypt(plaintext));
    }

    @Test
    void encrypt_withNullValue_returnsNullRatherThanThrowing() {
        assertNull(SecurityManager.encrypt(null));
    }

    @Test
    void decrypt_withNullValue_returnsNullRatherThanThrowing() {
        assertNull(SecurityManager.decrypt(null));
    }

}