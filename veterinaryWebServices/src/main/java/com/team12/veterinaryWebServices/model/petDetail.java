package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.sql.Date;

@Entity
@Table(name = "petDetail")
public class petDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "petDetailID")
    private Long petDetailID;

    @ManyToOne
    @JoinColumn(name = "petID")
    private pet pet;

    @Column(name = "petDetailDATE")
    private Date petDetailDATE;

    @Column(name = "petDetailDES")
    private String petDetailDES;
}
