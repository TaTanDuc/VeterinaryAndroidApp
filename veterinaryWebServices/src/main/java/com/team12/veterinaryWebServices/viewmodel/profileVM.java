package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.profile;

public record profileVM(Long profileID, String roleNAME, String profileIMG, String profileNAME, String profileEMAIL, String GENDER, Long AGE, String PHONE) {
    public static profileVM from (profile p){

        return new profileVM(
                p.getProfileID(),
                p.getRole().getRoleNAME(),
                p.getProfileIMG(),
                p.getProfileNAME(),
                p.getProfileEMAIL(),
                p.getGENDER().name(),
                p.getAGE(),
                p.getPHONE()
        );
    }
}
