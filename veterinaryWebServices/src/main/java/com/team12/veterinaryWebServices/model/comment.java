package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.Date;
import java.util.Objects;

@Entity
@Data
@Table(name = "comment")
public class comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "commentID")
    private Long commentID;

    @Column(name = "commentDATE")
    private Date commentDATE;

    @Column(name = "commentRATING", columnDefinition = "INT DEFAULT 0")
    private int commentRATING;

    @Column(name = "CONTENT")
    private String CONTENT;

    @ManyToOne
    @JoinColumn(name = "serviceCODE", referencedColumnName = "serviceCODE")
    private service service;

    @ManyToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @Override
    public int hashCode() {
        return Objects.hash(commentID); // Use a unique identifier instead
    }
}
