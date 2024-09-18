package com.team12.veterinaryWebServices.security.jwt;

import com.team12.veterinaryWebServices.enums.ERRORCODE;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.userRepository;
import com.team12.veterinaryWebServices.security.dto.appException;
import com.team12.veterinaryWebServices.security.dto.authenticationResponse;
import com.team12.veterinaryWebServices.security.dto.loginRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class jwtServices {

    private final userRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public authenticationResponse authenticate(loginRequest request){

        profile user = userRepository.findUserByUsername(request.getUsername())
                .orElseThrow(() -> new appException(ERRORCODE.USER_EXISTED));

        boolean authenticated = passwordEncoder.matches(request.getPassword(), user.getUSERNAME());

        if(!authenticated)
            throw new appException(ERRORCODE.UNAUTHENTICATED);
    }

    private String generateToken (String username){

    }
}
