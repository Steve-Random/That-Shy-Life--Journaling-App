package com.thatshylife;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class AuthFiler extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal (HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain filterChain)
        throws ServletException, IOException{

        String path = request.getRequestURI();

        //Skipping filter for Auth endpoints
        if ((path.startsWith("/api/auth/"))){
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
