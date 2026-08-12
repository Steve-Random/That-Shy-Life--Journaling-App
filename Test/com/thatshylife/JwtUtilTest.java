package com.thatshylife;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.security.Key;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for {@link JwtUtil}. Since {@code secretKey} is a static field set via
 * an instance method ({@link JwtUtil#setSecretKey(String)}, normally injected
 * by Spring via {@code @value}), each test manually initializes it first -
 * there's no Spring context here, so no real dependency injection is involved.
 */

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
    void validateToken_withFreshlyGeneratedToken_returnsTrue() {
        String token = JwtUtil.generateToken("user-123");
        assertTrue(JwtUtil.validateToken(token));

    }

    @Test
    void validateToken_withMalformedToken_returnsFalse() {
        assertFalse(JwtUtil.validateToken("not-a-real-jwt"));
    }

    @Test
    void validateToken_withEmptyToken_returnsFalse() {
        assertFalse(JwtUtil.validateToken(""));
    }

    @Test
    void validateToken_withExpiredToken_returnsFalse() {
        Key key = Keys.hmacShaKeyFor(TEST_SECRET.getBytes());
        String expiredToken = Jwts.builder()
                        .setSubject("user-123")
                        .setIssuedAt(new Date(System.currentTimeMillis() - 1000 * 60 * 60 * 24 * 8))
                        .setExpiration(new Date(System.currentTimeMillis() - 1000 * 60 * 60 * 24))
                        .signWith(key, SignatureAlgorithm.HS256)
                        .compact();

        assertFalse(JwtUtil.validateToken(expiredToken));
    }

    @Test
    void validateToken_withTokenSignedByDifferentKey_returnsFalse() {
        Key wrongkey = Keys.hmacShaKeyFor("a completely different 32 byte secret-key!!".getBytes());
        String tokenFromWrongKey = Jwts.builder()
                .setSubject("user-123")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60))
                .signWith(wrongkey, SignatureAlgorithm.HS256)
                .compact();

        assertFalse(JwtUtil.validateToken(tokenFromWrongKey));
    }

    @Test
    void extractUserId_withMalformedToken_throwsJwtException() {
        assertThrows(io.jsonwebtoken.JwtException.class,
                () -> JwtUtil.extractUserId("not a real jwt"));
    }

    @Test
    void generateToken_setsExpirationToSevenDaysFromNow() {
        long before = System.currentTimeMillis();
        String token = JwtUtil.generateToken("user-123");

        Key key = Keys.hmacShaKeyFor(TEST_SECRET.getBytes());
        Date expiration = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getExpiration();

        long expectedExpiry = before + (1000 * 60 * 60 * 24 *7);
        long toleranceMillis = 5000;
        assertTrue(Math.abs(expiration.getTime() - expectedExpiry) < toleranceMillis);
    }

}