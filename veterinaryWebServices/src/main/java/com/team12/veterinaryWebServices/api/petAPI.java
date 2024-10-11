package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.petDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.petServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/pet")
public class petAPI {

    private final petServices petServices;

    @PostMapping("/getUserPets")
    public ResponseEntity<Object> getUserPets (@RequestBody petDTO request){
        Object o = petServices.getUserPets(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @PostMapping("/addPet")
    public ResponseEntity<Object> addPet (@RequestBody petDTO request){
        Object o = petServices.addPet(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @PostMapping("/updatePet")
    public ResponseEntity<Object> updatePet (@RequestBody petDTO request){
        Object o = petServices.updatePet(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
