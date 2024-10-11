package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class profileDTO {
    private Long userID;
    private String profileIMG;
    private String profileNAME;
    private Long AGE;
    private String PHONE;
}
