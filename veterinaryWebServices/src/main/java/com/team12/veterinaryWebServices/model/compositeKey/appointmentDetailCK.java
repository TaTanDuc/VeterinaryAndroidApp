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

    private invoice invoice;
    private appointment appointment;
    private service service;
    private storage storage;

    public appointmentDetailCK(invoice invoice, appointment appointment, service service, storage storage){
        this.invoice = invoice;
        this.appointment = appointment;
        this.service = service;
        this.storage = storage;
    }
}
