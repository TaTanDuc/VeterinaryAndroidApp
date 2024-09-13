package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "services")
public class service {

    @Id
    @Column(name = "serviceCODE")
    private String serviceCODE;

    @Column(name = "serviceNAME")
    private String serviceNAME;

    @Column(name = "PRICE")
    private int servicePRICE;

    @OneToMany(mappedBy = "service")
    private List<appointmentDetail> appointmentDetails;
}
