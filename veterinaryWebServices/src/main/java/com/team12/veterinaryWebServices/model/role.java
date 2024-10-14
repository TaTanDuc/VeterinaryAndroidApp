package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.enums.ROLE;
import jakarta.persistence.*;
import lombok.Data;

import java.lang.reflect.Type;
import java.util.Objects;

@Data
@Entity
public class role {

    @Id
    @Column(name = "roleCODE")
    @Enumerated(EnumType.STRING)
    private ROLE roleCODE;

    @Column(name = "roleNAME")
    private String roleNAME;

    @Override
    public int hashCode() {
        return Objects.hash(roleCODE); // Use a unique identifier instead
    }
}
