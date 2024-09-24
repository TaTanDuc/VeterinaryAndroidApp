package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.exception.appException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.repository.appointmentRepository;
import com.team12.veterinaryWebServices.viewmodel.appointmentVM;

import java.util.List;

@RequiredArgsConstructor
@Service
public class appointmentServices {

    private final appointmentRepository appointmentRepository;

    public List<appointmentVM> getAllAppointments(){
        return appointmentRepository.findAll()
                .stream()
                .map(appointmentVM::from)
                .toList();
    }

    public appException addAppointment (){



        return new appException("Appointment added successfully");
    }
}
