package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.role;

public record profileVM(Long profileID, String roleNAME, String profileNAME, String profileEMAIL, boolean GENDER, int AGE, String PHONE) {
    public static profileVM from (profile p){

        return new profileVM(
                p.getProfileID(),
                p.getRole().getRoleNAME(),
                p.getProfileNAME(),
                p.getProfileEMAIL(),
                p.isGENDER(),
                p.getAGE(),
                p.getPHONE()
        );
    }
}
