package farmlink_backend;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {

    // Secret key used to sign JWT tokens
    private static final String SECRET_KEY =
            "FarmLinkSuperSecretKeyForJWTAuthentication2026";

    // Token validity: 24 hours
    private static final long EXPIRATION_TIME =
            1000 * 60 * 60 * 24;

    private final SecretKey key;

    public JwtService() {
        this.key = Keys.hmacShaKeyFor(
                SECRET_KEY.getBytes(StandardCharsets.UTF_8)
        );
    }

    // Generate JWT token
    public String generateToken(User user) {

        Date now = new Date();

        Date expiration = new Date(
                now.getTime() + EXPIRATION_TIME
        );

        return Jwts.builder()
                .subject(user.getEmail())
                .claim("userId", user.getId())
                .claim("name", user.getName())
                .claim("role", user.getRole())
                .issuedAt(now)
                .expiration(expiration)
                .signWith(key)
                .compact();
    }

    // Extract email from JWT
    public String extractEmail(String token) {

        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload()
                .getSubject();
    }

    // Validate JWT token
    public boolean isTokenValid(String token, User user) {

        try {

            String email = extractEmail(token);

            return email.equals(user.getEmail());

        } catch (Exception e) {

            return false;
        }
    }
}
