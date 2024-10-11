package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.storage;

public record itemVM (String itemCODE ,Long itemID, String itemIMAGE, String itemNAME, String itemCATEGORY, String itemDESCRIPTION, long itemQUANTITY,long itemPRICE){

    public static itemVM from(storage i){
        return new itemVM(
                i.getItemCODE(),
                i.getItemID(),
                i.getItemIMAGE(),
                i.getItemNAME(),
                i.getItemCATEGORY().name(),
                i.getItemDESCRIPTION(),
                i.getINSTOCK(),
                i.getItemPRICE()
        );
    }
}
