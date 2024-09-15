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

    @OneToMany(mappedBy = "service")
    private List<appointmentDetail> appointmentDetails;
}
