package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.model.storage;

import java.util.List;

public record cartVM (Long cartID, Long profileID, List<cartDetails> cartDetails, long TOTAL) {
    public static cartVM from (cart c){

        List<cartDetails> cartDetails = c.getCartDetails()
                .stream()
                .map(cD ->  new cartDetails(
                        cD.getStorage().getItemCODE(),
                        cD.getStorage().getItemID(),
                        cD.getStorage().getItemIMAGE(),
                        cD.getStorage().getItemNAME(),
                        cD.getStorage().getItemPRICE(),
                        cD.getItemQUANTIY()
                )
                ).toList();

        return new cartVM(
                c.getCartID(),
                c.getProfile().getProfileID(),
                cartDetails,
                c.getTOTAL()
        );
    }

    private record cartDetails(String itemCODE, Long itemID ,String itemIMAGE, String itemNAME,long itemPRICE, int itemQUANTITY) {}
}
