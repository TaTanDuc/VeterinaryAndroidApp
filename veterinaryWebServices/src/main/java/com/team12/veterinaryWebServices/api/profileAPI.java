package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.profileDTO;
import com.team12.veterinaryWebServices.dto.userDTO;
import com.team12.veterinaryWebServices.exception.appException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.team12.veterinaryWebServices.service.profileServices;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/profile")
public class profileAPI {

    private final profileServices profileServices;

    @GetMapping("/user/get")
    public ResponseEntity<Object> getUserProfile(@RequestParam("userID") Long request){
        Object o = profileServices.getUserProfile(request);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }


    @PatchMapping("/user/update")
    public ResponseEntity<Object> updateUserProfile(@RequestBody profileDTO request){
        Object o = profileServices.updateUserProfile(request);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
