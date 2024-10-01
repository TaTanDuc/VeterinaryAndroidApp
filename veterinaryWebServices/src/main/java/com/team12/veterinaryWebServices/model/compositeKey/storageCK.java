package com.team12.veterinaryWebServices.model.compositeKey;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class storageCK implements Serializable {

    private String itemCODE;
    private Long itemID;

    public storageCK(String storageCODE,Long storageID){
        this.itemCODE = storageCODE;
        this.itemID = storageID;
    }
}
