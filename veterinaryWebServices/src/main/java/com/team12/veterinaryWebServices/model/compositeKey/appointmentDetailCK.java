package com.team12.veterinaryWebServices.model.compositeKey;

import com.team12.veterinaryWebServices.model.appointment;
import com.team12.veterinaryWebServices.model.invoice;
import com.team12.veterinaryWebServices.model.service;
import com.team12.veterinaryWebServices.model.storage;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class appointmentDetailCK implements Serializable {

    private Long apmDetailID;
    private invoice invoice;
    private appointment appointment;

    public appointmentDetailCK(Long apmDetailID, invoice invoice, appointment appointment){
        this.invoice = invoice;
        this.appointment = appointment;
        this.apmDetailID = apmDetailID;
    }
}
