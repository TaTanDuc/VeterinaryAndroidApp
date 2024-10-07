package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.profileDTO;
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

    @PostMapping("/user/get")
    public ResponseEntity<Object> getUserProfile(@RequestBody profileDTO request){
        Object o = profileServices.getUserProfile(request);

        return ResponseEntity.ok(o);
    }

}
