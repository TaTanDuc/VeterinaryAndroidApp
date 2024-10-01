package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class authenticationRequest {
    private String USERNAME;
    private String PASSWORD;
}
