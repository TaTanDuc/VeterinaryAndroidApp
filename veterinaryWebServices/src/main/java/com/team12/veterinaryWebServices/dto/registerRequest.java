package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class registerRequest {
    private String USERNAME;
    private String EMAIL;
    private String PASSWORD;
}
