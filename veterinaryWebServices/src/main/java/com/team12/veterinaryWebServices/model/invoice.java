package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.model.compositeKey.invoiceCK;
import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.mapping.Join;

import java.io.Serializable;
import java.sql.Date;
import java.util.Collection;
import java.util.List;

@Entity
@Data
@IdClass(invoiceCK.class)
@Table(name = "invoice")
public class invoice {

    @Id
    @Column(name = "invoiceCODE")
    private String invoiceCODE;

    @Id
    @Column(name = "invoiceID")
    private Long invoiceID;

    @Column(name = "invoiceDATE")
    private Date invoiceDATE;

    @Column(name = "TOTAL", columnDefinition = "INT DEFAULT 0")
    private long TOTAL;

    @OneToMany(mappedBy = "invoice")
    private List<appointmentDetail> appointmentDetails;

    @OneToMany(mappedBy = "invoice")
    private List<buyDetail> buyDetail;

    @ManyToOne
    @JoinColumn(name = "profileID")
    private profile profile;
}
