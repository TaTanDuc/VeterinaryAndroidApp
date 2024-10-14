package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class profileDTO {
    private Long userID;
    private String profileIMG;
    private String profileNAME;
    private String profileEMAIL;
    private boolean GENDER;
    private Long AGE;
    private String PHONE;
}
