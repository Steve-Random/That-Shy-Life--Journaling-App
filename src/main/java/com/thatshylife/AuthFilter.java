package com.thatshylife;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Servlet filter that enforces JWT authentication on every request,
 * except those under {@code /api/auth/} and CORS preflight
 * ({@code OPTIONS}) requests.
 * <p>
 *     On success populates the {@code "userId"} request attribute (read
 *     by downstream controllers such as {@link JournalController}) by
 *     extracting it from the token via {@link JwtUtil#extractUserId(String)}.
 * </p>
 */
@Component
public class AuthFilter extends OncePerRequestFilter {
    /**
     * Validates the request {@code Authaurization: Bearer <token>} header
     * before allowing it through the filter chain.
     *
     * @throws jakarta.servlet.ServletException per {@link OncePerRequestFilter}'s contract
     * Responds directly with 401 Unauthorized without throwing if the header is missing,
     * malformed, or the token fails validation.
     */
    @Override
    protected void doFilterInternal (HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain filterChain)
        throws ServletException, IOException{

        String path = request.getRequestURI();

        //Skipping filter for Auth endpoints
        String method = request.getMethod();
        if ((path.startsWith("/api/auth/")) || (method.equals("OPTIONS")) ){
            filterChain.doFilter(request,response);
            return;
        }

        //Checking for Authorization header
        String authHeader = request.getHeader("Authorization");

        if((authHeader == null) || (!authHeader.startsWith("Bearer"))){
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Missing or invalid token");
            return;
        }

        //Extracting and Validating token
        String token = authHeader.substring(7);

        if(!JwtUtil.validateToken(token)){
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Invalid or expired token");
            return;
        }
        //Storing user ID in request for use in controller
        String userId = JwtUtil.extractUserId(token);
        request.setAttribute("userId", userId);

        filterChain.doFilter(request,response);

    }
}
