package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.registerRequest;
import com.team12.veterinaryWebServices.enums.ROLE;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.role;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class userServices {

    private final profileRepository profileRepository;

    public String register (registerRequest request){

        if(profileRepository.findByEmailOrUsername(request.getUSERNAME(),request.getEMAIL()).isPresent()){
            return ERRORCODE.USER_EXISTED.name();
        }

        profile user = new profile();
        role r = new role();
        r.setRoleCODE(ROLE.CUS);
        user.setUSERNAME(request.getUSERNAME());
        user.setProfileEMAIL(request.getEMAIL());
        user.setRole(r);
        user.setPASSWORD(request.getPASSWORD());

        profileRepository.save(user);

        return "User registered successfully!";
    }
}
