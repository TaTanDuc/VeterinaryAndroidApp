package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Data
@Entity
@Table(name = "cart")
public class cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cartID")
    private Long cartID;

    @OneToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @OneToMany(mappedBy = "cart")
    private List<cartDetail> cartDetails;

    @Column(name = "TOTAL")
    private Long TOTAL;
}
