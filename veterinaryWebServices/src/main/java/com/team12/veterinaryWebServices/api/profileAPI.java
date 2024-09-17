package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.model.profile;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import com.team12.veterinaryWebServices.service.profileServices;
import com.team12.veterinaryWebServices.security.JWT.JwtServices;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/profile")
public class profileAPI {

    private final profileServices profileServices;

    @GetMapping("/all")
    public ResponseEntity<List<profileVM>> allProfiles(){
        return ResponseEntity.ok(profileServices.getAllProfiles());
    }
}
