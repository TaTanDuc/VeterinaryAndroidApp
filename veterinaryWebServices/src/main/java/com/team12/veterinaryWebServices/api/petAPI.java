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

    @GetMapping("/mypets")
    public ResponseEntity<Object> getUserPets(@RequestParam("userID") Long userID){
        List<petVM> userPets = petServices.getUserPets(userID);

        if (userPets.isEmpty())
            return ResponseEntity.ok("You haven't registered any pet!");

        return ResponseEntity.ok(userPets);
    }

    @PostMapping("/employee/add")
    public ResponseEntity<Object> addUserPet(@RequestBody petDTO data){
        appException add = petServices.addUserPet(data);
        return new ResponseEntity<>(add.getMessage(),add.getErrorCode());
    }

    @PutMapping("/update")
    public ResponseEntity<Object> updateUserPet(@RequestBody petDTO data){
        appException update = petServices.updateUserPet(data);
        return new ResponseEntity<>(update.getMessage(),update.getErrorCode());
    }

    @DeleteMapping("/delete")
    public ResponseEntity<Object> deleteUserPet(@RequestParam("petID") Long petID,
                                                @RequestParam("userID") Long userID){
        appException delete = petServices.deleteUserPet(petID,userID);
        return new ResponseEntity<>(delete.getMessage(),delete.getErrorCode());
    }

    @GetMapping("/getdetails")
    public ResponseEntity<Object> getPetDetails(@RequestParam("petID") Long petID,
                                                @RequestParam("userID") Long userID){
        List<petDetailVM> petDetails = petServices.getPetDetails(petID,userID);

        if(petDetails.isEmpty())
            return ResponseEntity.ok("There is no detail for this pet yet!");

        return ResponseEntity.ok(petDetails);
    }
}
