package com.team12.veterinaryWebServices.security.JWT;

import lombok.Data;

@Data
public class AuthRequest {
    private String username;
    private String email;
    private String password;
}
