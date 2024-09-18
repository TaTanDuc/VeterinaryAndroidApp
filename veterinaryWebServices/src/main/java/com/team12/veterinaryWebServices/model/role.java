package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.List;

@Entity
@Data
@Table(name = "role")
public class role {

    @Id
    @Enumerated(EnumType.STRING)
    @Column(name = "roleCODE")
    private String roleCODE;

    @Column(name = "roleNAME")
    private String roleNAME;

    @OneToMany(mappedBy = "role")
    private List<profile> profiles;
}
