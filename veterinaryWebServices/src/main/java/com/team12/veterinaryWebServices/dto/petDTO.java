package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class petDTO {
    private Long userID;
    private Long petID;
    private String petIMAGE;
    private String petNAME;
    private String petSPECIE;
    private int petAGE;
}
