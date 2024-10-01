package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.petDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.petDetail;
import com.team12.veterinaryWebServices.service.petServices;
import com.team12.veterinaryWebServices.viewmodel.petDetailVM;
import com.team12.veterinaryWebServices.viewmodel.petVM;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/pet")
public class petAPI {

    private final petServices petServices;

    @GetMapping("/getUserPets")
    public ResponseEntity<Object> getUserPets (@RequestBody petDTO request){
        Object o = petServices.getUserPets(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/getPetDetails")
    public ResponseEntity<Object> getPetDetails (@RequestBody petDTO request){
        Object o = petServices.getPetDetail(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
