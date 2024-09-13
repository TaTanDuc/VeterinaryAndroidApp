package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

@Entity
@Table(name = "buyDetail")
public class buyDetail {

    @Id
    @OneToOne
    @JoinColumns(
            {
                @JoinColumn(name = "invoiceCODE", referencedColumnName = "invoiceCODE"),
                @JoinColumn(name = "invoiceID", referencedColumnName = "invoiceID")
            }
    )
    private invoice invoice;

    @ManyToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @Id
    @ManyToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "itemCODE", referencedColumnName = "itemCODE"),
                    @JoinColumn(name = "itemID", referencedColumnName = "itemID")
            }
    )
    private storage storage;

    @Column(name = "itemQUANTITY")
    private int itemQUANTITY;
}
