package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Data
@Table(name = "services")
public class service {

    @Id
    @Column(name = "serviceCODE")
    private String serviceCODE;

    @Column(name = "serviceNAME")
    private String serviceNAME;

    @Column(name = "PRICE")
    private Long servicePRICE;

    @Column(name = "RATING" , columnDefinition = "double default 0")
    private double serviceRATING;

    @Column(name = "serviceDATE")
    private String serviceDATE;

    @OneToMany(mappedBy = "service", cascade = CascadeType.ALL)
    private List<comment> comments;

    @OneToMany(mappedBy = "service")
    private List<appointmentDetail> appointmentDetails;
}
