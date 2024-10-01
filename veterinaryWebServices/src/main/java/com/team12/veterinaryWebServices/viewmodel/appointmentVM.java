package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.appointment;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public record appointmentVM (Long appointmentID, Date apmDATE, String profileNAME, Time appointmentTIME, List<apmDetails> appointmentDetails) {
    public static appointmentVM from (appointment a){

        List<apmDetails> appointmentDetails = a.getAppointmentDetails()
                .stream()
                .map(aD -> new apmDetails(
                        aD.getService().getServiceNAME(),
                        aD.getService().getServicePRICE(),
                        aD.getStorage().getItemNAME(),
                        aD.getStorage().getItemPRICE()
                )
                ).toList();

        return new appointmentVM(
                a.getAppointmentID(),
                a.getAppointmentDATE(),
                a.getProfile().getProfileNAME(),
                a.getAppointmentTIME(),
                appointmentDetails
        );
    }

    private record apmDetails (String serviceNAME, Long servicePRICE, String itemNAME, Long itemPRICE) {}
}
