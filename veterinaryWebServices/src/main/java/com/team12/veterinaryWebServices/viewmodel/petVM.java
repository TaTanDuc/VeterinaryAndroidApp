package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.pet;

public record petVM (Long petID, String imageLink , String petNAME, String petSPECIE, int petAGE){
    public static petVM from (pet p){

        return new petVM(
                p.getPetID(),
                p.getPetIMAGE(),
                p.getPetNAME(),
                p.getPetSPECIE(),
                p.getPetAGE()
        );
    }
}
