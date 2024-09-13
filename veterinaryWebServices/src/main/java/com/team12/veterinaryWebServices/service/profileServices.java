package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import java.util.List;

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
}
