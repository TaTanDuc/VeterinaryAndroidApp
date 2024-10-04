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

    public Object getUserPets (petDTO request){
        List<pet> list = petRepository.getProfilePets(request.getUserID());

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_PET_FOUND);

        return list.stream().map(petVM::from);
    }

    public Object getPetDetail (petDTO request){
        List<petDetail> list = petDetailRepository.getPetDetails(request.getPetID());

        if (list.isEmpty())
            return new appException(ERRORCODE.NO_PET_DETAIL_FOUND);

        return list.stream().map(petDetailVM::from).toList();
    }

//    public Object addPet (petDTO request){
//        profile p = profileRepository.getProfileById(request.getUserID());
//
//        if (p == null)
//            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);
//
//        pet pet = new pet();
//        pet.set
//
//    }
}
