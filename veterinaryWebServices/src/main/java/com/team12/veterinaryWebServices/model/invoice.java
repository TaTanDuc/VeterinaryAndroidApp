package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.sql.Date;
import java.util.Collection;
import java.util.List;

@Entity
@IdClass(invoice.invoiceCK.class)
@Table(name = "invoice")
public class invoice {

    @Id
    @Column(name = "invoiceCODE")
    private String invoiceCODE;

    @Id
    @Column(name = "invoiceID")
    private Long invoiceID;

    public static class invoiceCK implements Serializable {

        private String invoiceCODE;

        private Long invoiceID;

        public invoiceCK(String invoiceCODE,Long invoiceID){
            this.invoiceCODE = invoiceCODE;
            this.invoiceID = invoiceID;
        }
    }

    @Column(name = "invoiceDATE")
    private Date invoiceDATE;

    @Column(name = "TOTAL")
    private int TOTAL;

    @OneToOne(mappedBy = "invoice")
    private appointmentDetail appointmentDetails;

    @OneToOne(mappedBy = "invoice")
    private buyDetail buyDetail;
}
