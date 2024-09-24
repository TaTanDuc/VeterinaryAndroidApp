package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.enums.gender;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Data
@Table(name = "profile")
public class profile {

    @Id
    @Column(name = "profileID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long profileID;

    @ManyToOne
    @JoinColumn(name = "roleCODE", referencedColumnName = "roleCODE")
    private role role;

    @Column(name = "profileIMG")
    private String profileIMG;

    @Column(name = "profileNAME")
    private String profileNAME;

    @Column(name = "EMAIL", unique = true)
    private String profileEMAIL;

    @Enumerated(EnumType.STRING)
    @Column(name = "GENDER")
    private gender GENDER;

    @Column(name = "AGE")
    private Long AGE;

    @Column(name = "PHONE")
    private String PHONE;

    @Column(name = "USERNAME", unique = true)
    private String USERNAME;

    @Column(name = "PASSWORD")
    private String PASSWORD;

    @OneToMany(mappedBy = "profile")
    private List<appointment> appointments;

    @OneToMany(mappedBy = "profile")
    private List<buyDetail> buyDetails;

    @OneToMany(mappedBy = "profile")
    private List<pet> pets;

    @OneToMany(mappedBy = "profile")
    private List<comment> comments;

    @OneToOne(mappedBy = "profile")
    private cart cart;
}
