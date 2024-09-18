package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.enums.ERRORCODE;
import com.team12.veterinaryWebServices.repository.userRepository;
import com.team12.veterinaryWebServices.security.dto.registerRequest;
import com.team12.veterinaryWebServices.enums.roleEnum;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class userServices {

    private final userRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public String register (registerRequest registerINFO){
        if(userRepository.findUserByEmail(registerINFO.getEmail()).isPresent() || userRepository.findUserByUsername(registerINFO.getUsername()).isPresent()){
            return ERRORCODE.USER_EXISTED.name();
        }

        registerINFO.setPassword(passwordEncoder.encode(registerINFO.getPassword()));

        String role = roleEnum.CUS.name();
        registerINFO.setRole(role);
        userRepository.save(registerINFO);
        return "User registered successfully!";
    }
}
