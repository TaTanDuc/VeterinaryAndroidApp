package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "cartDetail")
public class cartDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cartDetailID")
    private Long cartDetailID;

    @ManyToOne
    @JoinColumn(name = "cartID", referencedColumnName = "cartID")
    private cart cart;

    @ManyToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "itemCODE", referencedColumnName = "itemCODE"),
                    @JoinColumn(name = "itemID", referencedColumnName = "itemID")
            }
    )
    private storage storage;

    @Column(name = "itemQUANTITY", columnDefinition = "INT DEFAULT 0")
    private int itemQUANTIY;
}
