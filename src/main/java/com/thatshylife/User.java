package com.thatshylife;

import java.time.LocalDateTime;
import java.util.UUID;

public class User {

    private String id;
    private String email;
    private String password;
    private LocalDateTime createdAt;

    public User(){
        this.id = UUID.randomUUID().toString();
        this.createdAt = LocalDateTime.now();
    }

    //Setters
    public void setId(String id){ this.id = id;}
    public void setEmail(String email){ this.email = email;}
    public void setPassword(String password){ this.password = password;}
    public void setCreatedAt(LocalDateTime createdAt){ this.createdAt = createdAt;}

    //Getters
    public String getId(){ return id;}
    public String getEmail(){ return email;}
    public String getPassword(){ return  password;}
    public LocalDateTime getCreatedAt(){ return createdAt; }


}
