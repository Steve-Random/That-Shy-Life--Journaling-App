package com.thatshylife;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.security.Key;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

class JwtUtilTest {

    private static final String TEST_SECRET = "test-secret-key-that-is-atleast-32-bytes-long!";

    @BeforeEach
    void setUp(){
        new JwtUtil().setSecretKey(TEST_SECRET);
    }

    @Test
    void generateToken_thenExtractUserId_returnsOriginalUserId() {
        String token = JwtUtil.generateToken("user-123");
        assertEquals("user-123", JwtUtil.extractUserId(token));
    }


    @Test
    void validateToken() {

    }

    @Test
    void extractUserId() {

    }

}