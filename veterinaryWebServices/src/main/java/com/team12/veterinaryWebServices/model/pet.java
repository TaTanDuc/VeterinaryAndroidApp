package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Data
@Table(name = "pet")
public class pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "petID")
    private Long petID;

    @Column(name = "petIMAGE")
    private String petIMAGE;

    @ManyToOne
    @JoinColumn(name = "profileID")
    private profile profile;

    @Column(name = "petSPECIE")
    private String petSPECIE;

    @Column(name = "petNAME")
    private String petNAME;

    @Column(name = "petAGE", columnDefinition = "INT DEFAULT 1")
    private int petAGE;

    @OneToMany(mappedBy = "pet")
    private List<appointment> appointment;
}
