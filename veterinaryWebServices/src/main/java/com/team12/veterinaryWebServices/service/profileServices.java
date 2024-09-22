package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class profileServices {

    private final profileRepository profileRepository;

    public List<profileVM> getAllProfiles(){
        return profileRepository.findAll()
                .stream()
                .map(profileVM::from)
                .toList();
    }

    public String updateProfile(profile p){
        profile user = profileRepository.findByEmailOrUsername(p.getUSERNAME(), p.getProfileEMAIL());

        if(user != null) throw new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        profileRepository.save(p);
        return "Profile update successfully!";
    }
}
