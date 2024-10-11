package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class commentDTO {
    private Long userID;
    private String serviceCODE;
    private int rating;
    private String content;
}
