package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.loginRequest;
import com.team12.veterinaryWebServices.dto.registerRequest;
import com.team12.veterinaryWebServices.enums.ROLE;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.role;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Service;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class userServices {

    private final profileRepository profileRepository;

    public appException register (registerRequest request){

        profile register = profileRepository.getByEmailOrUsername(request.getUSERNAME(),request.getPASSWORD());
        if (register != null){
            return new appException(ERRORCODE.USER_EXISTED);
        }

        profile user = new profile();
        role r = new role();
        r.setRoleCODE(ROLE.CUS);
        user.setUSERNAME(request.getUSERNAME());
        user.setProfileEMAIL(request.getEMAIL());
        user.setRole(r);
        user.setPASSWORD(request.getPASSWORD());

        profileRepository.save(user);

        return new appException("User registered successfully!");
    }

    public appException login (loginRequest request){

        profile user = profileRepository.getByEmailOrUsername(request.getLOGINSTRING(),request.getLOGINSTRING());
        if (user != null){
            if (user.getPASSWORD().equals(request.getPASSWORD()))
                return new appException("User logged in successfully!");
            else
                return new appException(ERRORCODE.PASSWORD_NOT_MATCH);
        }
        return new appException(ERRORCODE.USER_DOES_NOT_EXIST);
    }
}
