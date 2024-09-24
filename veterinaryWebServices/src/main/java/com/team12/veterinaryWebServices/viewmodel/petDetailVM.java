package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.petDetail;

import java.util.Date;

public record petDetailVM (String petNAME, String petSPECIE, Long petAGE, Date petDetailDATE, String petDetailDES){
    public static petDetailVM from (petDetail pD){
        return new petDetailVM(
                pD.getPet().getPetNAME(),
                pD.getPet().getPetSPECIE(),
                pD.getPet().getPetAGE(),
                pD.getPetDetailDATE(),
                pD.getPetDetailDES()
        );
    }
}
