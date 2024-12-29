package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.petDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.pet;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.repository.petDetailRepository;
import com.team12.veterinaryWebServices.repository.petRepository;
import com.team12.veterinaryWebServices.repository.profileRepository;
import com.team12.veterinaryWebServices.viewmodel.petVM;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@RequiredArgsConstructor
@Service
public class petServices {

    private final profileRepository profileRepository;
    private final petRepository petRepository;
    private final petDetailRepository petDetailRepository;

    public Object getUserPets (petDTO request){
        List<pet> list = petRepository.getProfilePets(request.getUserID());

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_PET_FOUND);

        return list.stream().map(petVM::from);
    }

    public Object addPet (petDTO request){
        profile p = profileRepository.getProfileById(request.getUserID());

        if (p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        pet pet = new pet();
        pet.setProfile(p);
        pet.setPetIMAGE(request.getPetIMAGE());
        pet.setPetSPECIE(request.getPetSPECIE());
        pet.setPetNAME(request.getPetNAME());
        pet.setPetAGE(request.getPetAGE());

        petRepository.save(pet);

        return new appException("Pet added successfully!");
    }

    public Object updatePet (petDTO request){
        profile p = profileRepository.getProfileById(request.getUserID());
        if(p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        pet pet = petRepository.getPetById(request.getPetID());
        if(pet == null)
            return new appException(ERRORCODE.NO_PET_FOUND);

        if(!Objects.equals(pet.getProfile().getProfileID(), p.getProfileID()))
            return new appException(ERRORCODE.NOT_PET_OWNER);

        pet.setPetIMAGE(request.getPetIMAGE());
        pet.setPetNAME(request.getPetNAME());
        pet.setPetSPECIE(request.getPetSPECIE());
        pet.setPetAGE(request.getPetAGE());
        petRepository.save(pet);

        return new appException("Pet updated successfully!");
    }
}

