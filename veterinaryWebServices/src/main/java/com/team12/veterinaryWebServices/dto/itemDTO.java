package com.team12.veterinaryWebServices.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class itemDTO {
    private Long userID;
    private Long cartID;
    private String itemCODE;
    private Long itemID;
    private int QUANTITY;
}
