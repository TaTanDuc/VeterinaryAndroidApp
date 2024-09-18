package com.team12.veterinaryWebServices.security.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class loginRequest {
    private String username;
    private String password;
}
