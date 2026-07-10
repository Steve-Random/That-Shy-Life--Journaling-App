package com.thatshylife;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

@Component
public class SecurityManager {
    // A 16 character key for AES-128
    private static String secretKey;
    private static final String ALGORITHM = "AES";

    @Value("${SECRET_KEY}")
    public void setSecretKey(String secretKey){
        SecurityManager.secretKey = secretKey;
    }

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
