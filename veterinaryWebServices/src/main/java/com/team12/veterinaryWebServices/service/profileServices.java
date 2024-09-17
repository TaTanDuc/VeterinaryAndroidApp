package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.security.JWT.LoginDetail;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class profileServices implements UserDetailsService {

    private final profileRepository profileRepository;
    private final PasswordEncoder passwordEncoder;

    public List<profileVM> getAllProfiles(){
        return profileRepository.findAll()
                .stream()
                .map(profileVM::from)
                .toList();
    }

    public String addProfile(profile profile){

        if(profileRepository.existsProfileByEmail(profile.getProfileEMAIL()) || profileRepository.existsProfileByUsername(profile.getUSERNAME()))
            return "Profile already exist";

        profile.setPASSWORD(passwordEncoder.encode(profile.getPASSWORD()));
        profileRepository.save(profile);
        return "Profile added successfully";
    }

    @Override
    public UserDetails loadUserByUsername (String username) throws UsernameNotFoundException {

        Optional<profile> userDetail = Optional.empty();

        if (profileRepository.existsProfileByUsername(username))
            userDetail = profileRepository.findProfileByUsername(username);

        else if (profileRepository.existsProfileByEmail(username))
            userDetail = profileRepository.findProfileByEmail(username);

        return userDetail.map(LoginDetail::new)
                .orElseThrow(() -> new UsernameNotFoundException("User "+ username +" is not found!"));
    }
}
