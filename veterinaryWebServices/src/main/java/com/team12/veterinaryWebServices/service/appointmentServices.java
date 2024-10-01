package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.appointmentDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.*;
import com.team12.veterinaryWebServices.repository.appointmentDetailRepository;
import com.team12.veterinaryWebServices.repository.invoiceRepository;
import com.team12.veterinaryWebServices.repository.profileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.team12.veterinaryWebServices.repository.appointmentRepository;
import com.team12.veterinaryWebServices.viewmodel.appointmentVM;

import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class appointmentServices {

    private final appointmentRepository appointmentRepository;
    private final appointmentDetailRepository appointmentDetailRepository;
    private final profileRepository profileRepository;
    private final invoiceRepository invoiceRepository;

    public Object getAllAppointments(){
        List<appointment> list = appointmentRepository.findAll();

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

    public Object addAppointment(appointmentDTO request){

        profile p = profileRepository.getProfileById(request.getProfileID());

        if(p == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);

        List<appointment> list = appointmentRepository.getAppointmentByDateAndTime(request.getAppointmentDATE(),request.getAppointmentTIME());

        if (list.size() >= 5)
            return new appException(ERRORCODE.APPOINTMENT_FULL);

        if (request.getServices().isEmpty())
            return new appException(ERRORCODE.NO_SERVICE_IN_APPOINTMENT);


        List<appointmentDetail> aDList = new ArrayList<>();
        appointment a = new appointment();
        invoice i = new invoice();

        i.setInvoiceCODE("A");
        i.setInvoiceID((long) invoiceRepository.findAllByInvoiceCode("A").size() + 1);

        invoiceRepository.save(i);

        for(service s : request.getServices()){
            appointmentDetail aD = new appointmentDetail();
            aD.setService(s);
            aD.setInvoice(i);
            aDList.add(aD);
            appointmentDetailRepository.save(aD);
        }

        a.setProfile(p);
        a.setAppointmentDATE(request.getAppointmentDATE());
        a.setAppointmentTIME(request.getAppointmentTIME());
        a.setAppointmentDetails(aDList);

        appointmentRepository.save(a);
        return new appException("Appointment added successfully!");
    }
}
