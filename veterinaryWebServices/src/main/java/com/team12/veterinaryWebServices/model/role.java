package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "role")
public class role {

    @Id
    @Column(name = "roleCODE")
    private String roleCODE;

    @Column(name = "roleNAME")
    private String roleNAME;

    @OneToMany(mappedBy = "role")
    private List<profile> profiles;
}
