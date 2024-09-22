package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.pet;

public record petVM (Long petID, String petNAME, String petSPECIE, Long petAGE){
    public static petVM from (pet p){

        return new petVM(
                p.getPetID(),
                p.getPetNAME(),
                p.getPetSPECIE(),
                p.getPetAGE()
        );
    }
}
