package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.security.JWT.AuthRequest;
import com.team12.veterinaryWebServices.security.JWT.JwtServices;
import com.team12.veterinaryWebServices.service.profileServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.authentication.AuthenticationManager;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api")
public class userAPI {

    private final JwtServices jwtServices;
    private final profileServices profileServices;
    private AuthenticationManager authenticationManager;

    @PostMapping("/register")
    public ResponseEntity<String> registerProfile(@RequestBody profile profile){
        return ResponseEntity.ok(profileServices.addProfile(profile));
    }

    @PostMapping("/generateToken")
    public String authenticateAndGetToken(@RequestBody AuthRequest authRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword())
        );
        if (authentication.isAuthenticated()) {
            return jwtServices.generateToken(authRequest.getUsername());
        } else {
            throw new UsernameNotFoundException("Invalid user request!");
        }
    }
}
