package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.service.profileServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.authentication.AuthenticationManager;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
public class userAPI {

    private final profileServices profileServices;
    private AuthenticationManager authenticationManager;

    @PostMapping("/register")
    public ResponseEntity<String> registerProfile(@RequestBody profile profile){
        return ResponseEntity.ok(profileServices.addProfile(profile));
    }

}
