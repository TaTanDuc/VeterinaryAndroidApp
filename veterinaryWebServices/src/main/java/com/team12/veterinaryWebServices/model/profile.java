package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "profile")
public class profile {

    @Id
    @Column(name = "profileID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long profileID;

    @ManyToOne
    @JoinColumn(name = "roleCODE", referencedColumnName = "roleCODE")
    private role role;

    @Column(name = "profileNAME")
    private String profileNAME;

    @Column(name = "EMAIL")
    private String profileEMAIL;

    @Column(name = "GENDER")
    private boolean GENDER;

    @Column(name = "AGE")
    private int AGE;

    @Column(name = "PHONE")
    private String PHONE;

    @Column(name = "USERNAME")
    private String USERNAME;

    @Column(name = "PASSWORD")
    private String PASSWORD;

    @OneToMany(mappedBy = "profile")
    private List<appointment> appointments;

    @OneToMany(mappedBy = "profile")
    private List<buyDetail> buyDetails;

    @OneToMany(mappedBy = "profile")
    private List<pet> pets;
}
