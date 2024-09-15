package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.model.compositeKey.appointmentDetailCK;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@IdClass(appointmentDetailCK.class)
@Table(name = "appointmentDetail")
public class appointmentDetail {

    @Id
    @Column(name = "apmDetailID")
    private Long apmDetailID;

    @Id
    @ManyToOne
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
    private Long itemQUANTITY;
}
