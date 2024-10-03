package com.team12.veterinaryWebServices.model.compositeKey;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@NoArgsConstructor
@Data
public class storageCK implements Serializable {

    private String itemCODE;
    private Long itemID;

    public storageCK(String itemCODE,Long itemID){
        this.itemCODE = itemCODE;
        this.itemID = itemID;
    }
}
