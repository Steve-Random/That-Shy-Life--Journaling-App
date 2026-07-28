package com.thatshylife;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

/**
 * Handles JWT creation, parsing , and validation for authenticating
 * users across requests
 * <p>
 *     The signing key is injected at startup via {@code SECRET_KEY} and
 *     shared across all tokens; it must remain stable for previously
 *     issued tokens to keep validating
 * </p>
 */
@Component
public class JwtUtil {

    private static Key secretKey;

    @Value("${SECRET_KEY}")
    public void setSecretKey( String secret ){
        secretKey =Keys.hmacShaKeyFor(secret.getBytes());
    }

    /**
     * Generates a signed JWT for the given user, valid for 7 days from
     * issuance
     *
     * @param userId the user ID to embed as the token's subject
     * @return a compact, signed JWT string
     */
    public static String generateToken(String userId){
        return Jwts.builder()
                .setSubject(userId)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24 *7)) // 7 days
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Extracts a user ID from a JWT previous issued by {@link #generateToken(String)}
     * @throws io.jsonwebtoken.JwtException if the token is invalid, expired,
     *   or its signature doesn't match
     */
    public static String extractUserId(String token){
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject();
    }

    /**
     * Checks whether a token is well-formed, correctly signed, and not
     * expired
     *
     * @return {@code true} if valid, {@code false} for any failure
     *      (malformed, expired, or bad signature) - never throws
     */
    public static boolean validateToken(String token){
        try{
            Jwts.parserBuilder()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        }catch (Exception e){
            return false;
        }
    }
}
