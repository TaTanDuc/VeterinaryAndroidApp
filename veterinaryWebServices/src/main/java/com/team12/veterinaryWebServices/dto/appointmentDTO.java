package com.team12.veterinaryWebServices.dto;

import com.team12.veterinaryWebServices.model.service;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Setter
@Getter
public class appointmentDTO {
    private Long userID;
    private Long petID;
    private Date appointmentDATE;
    private Time appointmentTIME;
    List<service> services;
}
