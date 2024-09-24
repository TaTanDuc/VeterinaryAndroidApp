package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.profile;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.team12.veterinaryWebServices.viewmodel.profileVM;
import com.team12.veterinaryWebServices.service.profileServices;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/profile")
public class profileAPI {

    private final profileServices profileServices;

    @GetMapping("/admin/all")
    public ResponseEntity<Object> allProfiles(){
        return ResponseEntity.ok(profileServices.getAllProfiles());
    }

    @PutMapping("/update")
    public ResponseEntity<Object> updateUserProfile(@RequestBody profile p){
        appException update = profileServices.updateProfile(p);
        return new ResponseEntity<>(update.getMessage(),update.getErrorCode());
    }
}
