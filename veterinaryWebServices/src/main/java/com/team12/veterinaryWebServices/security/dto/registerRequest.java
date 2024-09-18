package com.team12.veterinaryWebServices.security.dto;

import com.team12.veterinaryWebServices.model.profile;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class registerRequest extends profile {

    private Long id;
    private String username;
    private String email;
    private String password;
    private String role;
}
