package com.team12.veterinaryWebServices.dto;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class userDTO {
    private Long userID;
    private String userNAME;
    private String userEMAIL;
    private Long cartID;
}
