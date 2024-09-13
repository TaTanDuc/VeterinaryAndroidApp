package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

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

    @Column(name = "START")
    private Time START;

    @Column(name = "END")
    private Time END;

    @OneToMany(mappedBy = "appointment")
    private List<appointmentDetail> appointmentDetails;
}
