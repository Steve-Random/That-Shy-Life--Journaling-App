package com.thatshylife;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin( origins = {
        "http://localhost:8080",
        "http://localhost:60148",
        "https://that-shy-life-journaling-app.onrender.com",
        "https://that-shy-life-web.onrender.com"
})

public class AuthController {

    @Autowired
    private DatabaseManager databaseManager;

    @PostMapping("/register")
    public ResponseEntity<Map<String,String>> register (@RequestBody Map<String,String> request){
        String email = request.get("email");
        String password = request.get("password");

        //Checking if user already exists
        if (databaseManager.findUserByEmail(email)!=null){
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", "Email already registered"));
        }

        //Else we hash the password before saving
        String hashedPassword = SecurityManager.encrypt(password);

        User user = new User();
        user.setEmail(email);
        user.setPassword(hashedPassword);

        databaseManager.saveUser(user);

        String token = JwtUtil.generateToken(user.getId());
        return ResponseEntity.ok(Map.of("token", token));
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String,String>> login (@RequestBody Map<String,String> request){
        String email = request.get("email");
        String password = request.get("password");

        User user = databaseManager.findUserByEmail(email);

        if (user == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid email or password"));
        }

        //Checking password
        String hashedPassword = SecurityManager.encrypt(password);
        if(!hashedPassword.equals(user.getPassword())){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Invalid email or password"));
        }

        String token = JwtUtil.generateToken(user.getId());
        return ResponseEntity.ok(Map.of("token", token));
    }



}
