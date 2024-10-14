package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.appointmentDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.*;
import com.team12.veterinaryWebServices.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.viewmodel.appointmentVM;

import java.util.List;
import java.util.Objects;

@RequiredArgsConstructor
@Service
public class appointmentServices {

    private final appointmentRepository appointmentRepository;
    private final appointmentDetailRepository appointmentDetailRepository;
    private final profileRepository profileRepository;
    private final invoiceRepository invoiceRepository;
    private final petRepository petRepository;

    public Object getAllAppointments(){
        List<appointment> list = appointmentRepository.findAll();

        if (list.isEmpty())
            return new appException(ERRORCODE.NO_APPOINTMENT_FOUND);

        return list.stream().map(appointmentVM::from).toList();
    }

    public Object getUserAppointment(Long userID){
        profile p = profileRepository.getProfileById(userID);

        if(p == null)
            return  new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        List<appointment> list = appointmentRepository.getUserAppointment(userID);

        if (list.isEmpty())
            return new appException(ERRORCODE.NO_APPOINTMENT_FOUND);

        return list.stream().map(appointmentVM::from).toList();
    }

    public Object getWeekAppointments(){
        List<appointment> list = appointmentRepository.getThisWeekAppointment();

        if (list.isEmpty())
            return new appException(ERRORCODE.NO_APPOINTMENT_FOUND);

        return list.stream().map(appointmentVM::from).toList();
    }

    public appException addAppointment(appointmentDTO request){

        profile p = profileRepository.getProfileById(request.getUserID());
        pet pet = petRepository.getPetById(request.getPetID());

        if (p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        if (pet == null)
            return new appException(ERRORCODE.PET_DOES_NOT_EXIST);

        if (!Objects.equals(pet.getProfile().getProfileID(), p.getProfileID()))
            return new appException(ERRORCODE.NOT_PET_OWNER);

        List<appointment> list = appointmentRepository.getAppointmentByDateAndTime(request.getAppointmentDATE(),request.getAppointmentTIME());

        if (list.size() >= 5)
            return new appException(ERRORCODE.APPOINTMENT_FULL);

        if (request.getServices().isEmpty())
            return new appException(ERRORCODE.NO_SERVICE_IN_APPOINTMENT);

        appointment a = new appointment();
        a.setProfile(p);
        a.setPet(pet);
        a.setAppointmentDATE(request.getAppointmentDATE());
        a.setAppointmentTIME(request.getAppointmentTIME());
        appointmentRepository.save(a);

        invoice i = new invoice();

        i.setInvoiceCODE("A");
        i.setInvoiceID(invoiceRepository.countByCode("A")+ 1);
        i.setInvoiceDATE(request.getAppointmentDATE());

        invoiceRepository.save(i);

        for(service s : request.getServices()){
            appointmentDetail aD = new appointmentDetail();
            aD.setInvoice(i);
            aD.setApmDetailID(appointmentDetailRepository.count()+1);
            aD.setAppointment(a);
            aD.setService(s);
            appointmentDetailRepository.save(aD);
        }

        return new appException("Appointment added successfully!");
    }
}
