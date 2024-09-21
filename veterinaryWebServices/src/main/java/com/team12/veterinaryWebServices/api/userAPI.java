package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.registerRequest;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.userServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
public class userAPI {

    private final userServices userServices;

    @PostMapping("/register")
    public ResponseEntity<Object> registerUser(@RequestBody registerRequest request){
        appException register = userServices.register(request);
        return new ResponseEntity<>(register.getMessage(),register.getErrorCode());
    }
}
