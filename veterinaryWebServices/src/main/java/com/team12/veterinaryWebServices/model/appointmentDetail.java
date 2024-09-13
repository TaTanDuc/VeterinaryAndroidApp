package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

@Entity
@Table(name = "appointmentDetail")
public class appointmentDetail {

    @Id
    @OneToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "invoiceCODE", referencedColumnName = "invoiceCODE"),
                    @JoinColumn(name = "invoiceID", referencedColumnName = "invoiceID")
            }
    )
    private invoice invoice;

    @Id
    @ManyToOne
    @JoinColumn(name = "appointmentID", referencedColumnName = "appointmentID")
    private appointment appointment;

    @Id
    @ManyToOne
    @JoinColumn(name = "serviceCODE", referencedColumnName = "serviceCODE")
    private com.team12.veterinaryWebServices.model.service service;

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
