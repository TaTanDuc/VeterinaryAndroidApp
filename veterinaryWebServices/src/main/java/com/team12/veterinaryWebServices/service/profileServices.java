package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.profileDTO;
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

    public Object getUserProfile (profileDTO request){
        profile profile = profileRepository.getProfileById(request.getUserID());

        if (profile == null)
            return new appException(ERRORCODE.NO_PROFILE_FOUND);

        return profileVM.from(profile);
    }
}
