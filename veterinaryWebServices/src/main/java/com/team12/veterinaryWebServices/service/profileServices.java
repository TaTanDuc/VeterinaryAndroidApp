package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.profileDTO;
import com.team12.veterinaryWebServices.dto.userDTO;
import com.team12.veterinaryWebServices.enums.gender;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.profileVM;

@RequiredArgsConstructor
@Service
public class profileServices {

    private final profileRepository profileRepository;

    public Object getUserProfile (Long userID){
        profile profile = profileRepository.getProfileById(userID);

        if (profile == null)
            return new appException(ERRORCODE.NO_PROFILE_FOUND);

        return profileVM.from(profile);
    }

    public  Object updateUserProfile (profileDTO request){
        profile profile = profileRepository.getProfileById(request.getUserID());

        if (profile == null)
            return new appException(ERRORCODE.NO_PROFILE_FOUND);

        if(request.getGENDER() == true)
            profile.setGENDER(gender.MALE);
        else
            profile.setGENDER(gender.FEMALE);

        profile.setProfileIMG(request.getProfileIMG());
        profile.setProfileNAME(request.getProfileNAME());
        profile.setAGE(request.getAGE());
        profile.setPHONE(request.getPHONE());
        profileRepository.save(profile);

        return new appException("Profile updated successfully!");
    }
}
