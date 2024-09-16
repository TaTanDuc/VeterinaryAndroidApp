package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import java.util.List;

@RequiredArgsConstructor
@Service
public class profileServices {

    private final profileRepository profileRepository;
    private final PasswordEncoder passwordEncoder;

    public List<profileVM> getAllProfiles(){
        return profileRepository.findAll()
                .stream()
                .map(profileVM::from)
                .toList();
    }

    public String addProfile(profile profile){
        if(profileRepository.existByEmail(profile.getProfileEMAIL()) || profileRepository.existByUsername(profile.getUSERNAME()))
            return "Profile already exist";
        profile.setPASSWORD(passwordEncoder.encode(profile.getPASSWORD()));
        profileRepository.save(profile);
        return "Profile added successfully";
    }
}
