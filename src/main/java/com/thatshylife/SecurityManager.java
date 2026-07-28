package com.thatshylife;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

/**
 * Provides reversible encryption /decryption for sensitive fields
 * (journal content, micro-entries) before database storage.
 * <p>
 *     <b>Known limitation:</b> uses AES-128 in ECB mode with a single
 *     shared static key, which is reversible by design rather than a true
 *     one-way hash. This acceptable for now but should be migrated to
 *     Bcrypt-style hashing for anything that doesn't need to be recovered
 *     in plaintext (see project security debt notes)
 * </p>
 */
@Component
public class SecurityManager {
    private static String secretKey;
    private static final String ALGORITHM = "AES";

    @Value("${SECRET_KEY}")
    public void setSecretKey(String secretKey){
        SecurityManager.secretKey = secretKey;
    }

    /**
     * Encrypts a plaintext value using AES.
     *
     * @return the Base64-encoded ciphertext, or the original plaintext
     *      value unchanged if encryption fails for any reason.
     */
    public static String encrypt(String value){
        try {
            SecretKeySpec spec = new SecretKeySpec(secretKey.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, spec);
            byte[] encrypted = cipher.doFinal(value.getBytes());
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e){
            return value; // just write the plain text back if there is an error
        }
    }

    /**
     * Decrypts a Base64-encoded ciphertext previously produced by
     * {@link #encrypt(String)}.
     *
     * @return the decrypted plaintext, or the original {@code encryptedValue}
     *      unchanged if decryption fails ( e.g, the value was never encrypted
     *      in the first place, due to the {@link #encrypt(String)} fallback)
     */
    public static String decrypt (String encryptedValue){
        try{
            SecretKeySpec spec = new SecretKeySpec(secretKey.getBytes(),ALGORITHM);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, spec);
            byte[] decoded = Base64.getDecoder().decode(encryptedValue);
            return new String(cipher.doFinal(decoded));
        }catch (Exception e){
            return encryptedValue; //just write the encrypted data[--
        }
    }

}
