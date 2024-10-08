package com.team12.veterinaryWebServices.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.team12.veterinaryWebServices.service.profileServices;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/profile")
public class profileAPI {

    private final profileServices profileServices;

    @PostMapping("/user/get")
    public ResponseEntity<Object> getUserProfile(@RequestParam("userID") Long userID){
        Object o = profileServices.getUserProfile(userID);

        return ResponseEntity.ok(o);
    }

}
