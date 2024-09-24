package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.petDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.pet;
import com.team12.veterinaryWebServices.model.petDetail;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.petDetailRepository;
import com.team12.veterinaryWebServices.repository.petRepository;
import com.team12.veterinaryWebServices.repository.profileRepository;
import com.team12.veterinaryWebServices.viewmodel.petDetailVM;
import com.team12.veterinaryWebServices.viewmodel.petVM;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class petServices {

    private final profileRepository profileRepository;
    private final petRepository petRepository;
    private final petDetailRepository petDetailRepository;

    private ERRORCODE petERROR(profile p, pet pet){
        if(p == null)
            return ERRORCODE.USER_DOES_NOT_EXIST;
        if(pet == null)
            return ERRORCODE.PET_DOES_NOT_EXIST;
        if (!Objects.equals(pet.getProfile().getProfileID(), p.getProfileID()))
            return ERRORCODE.NOT_PET_OWNER;
        return null;
    }

    public List<petVM> getUserPets(Long userID){
        return petRepository.getProfilePets(userID)
                .stream()
                .map(petVM::from)
                .toList();
    }

    public appException addUserPet(petDTO data){
        profile p = profileRepository.getProfileById(data.getUserID());

        if(p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        pet userPet = new pet();
        userPet.setProfile(p);
        userPet.setPetNAME(data.getPetNAME());
        userPet.setPetSPECIE(data.getPetSPECIE());
        userPet.setPetAGE(data.getPetAGE());

        petRepository.save(userPet);

        return new appException("Pet added successfully!");
    }

    public appException updateUserPet(petDTO data){
        profile p = profileRepository.getProfileById(data.getUserID());
        pet pet = petRepository.getPetById(data.getPetID());
        ERRORCODE errorcode = petERROR(p,pet);

        if(errorcode != null)
            return new appException(errorcode);

        pet.setPetNAME(data.getPetNAME());
        pet.setPetSPECIE(data.getPetSPECIE());
        pet.setPetAGE(data.getPetAGE());

        petRepository.save(pet);
        return new appException("Pet updated successfully!");
    }

    public appException deleteUserPet(Long petID, Long userID){
        profile p = profileRepository.getProfileById(userID);
        pet pet = petRepository.getPetById(petID);
        ERRORCODE errorcode = petERROR(p,pet);

        if(errorcode != null)
            return new appException(errorcode);

        petRepository.delete(pet);
        return new appException("Deleted pet successfully");
    }

    public List<petDetailVM> getPetDetails(Long petID, Long userID){
        pet pet = petRepository.getPetById(petID);

        if(!Objects.equals(pet.getProfile().getProfileID(), userID))
            throw new appException(ERRORCODE.NOT_PET_OWNER);

        return petDetailRepository.getPetDetails(petID)
                .stream()
                .map(petDetailVM::from)
                .toList();
    }
}
