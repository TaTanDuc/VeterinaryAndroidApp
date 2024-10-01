package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "appointment")
public class appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long appointmentID;

    @ManyToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @Column(name = "appointmentDATE")
    private Date appointmentDATE;

    @Column(name = "appointmentTIME")
    private Time appointmentTIME;

    @OneToMany(mappedBy = "appointment")
    private List<appointmentDetail> appointmentDetails;
}
