package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.model.compositeKey.buyDetailCK;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@IdClass(buyDetailCK.class)
@Table(name = "buyDetail")
public class buyDetail {

    @Id
    @Column(name = "buyDetailID")
    private Long buyDetailID;

    @Id
    @ManyToOne
    @JoinColumns(
            {
                @JoinColumn(name = "invoiceCODE", referencedColumnName = "invoiceCODE"),
                @JoinColumn(name = "invoiceID", referencedColumnName = "invoiceID")
            }
    )
    private invoice invoice;

    @ManyToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "itemCODE", referencedColumnName = "itemCODE"),
                    @JoinColumn(name = "itemID", referencedColumnName = "itemID")
            }
    )
    private storage storage;

    @ManyToOne
    @JoinColumn(name = "profileID", referencedColumnName = "profileID")
    private profile profile;

    @Column(name = "itemQUANTITY")
    private Long itemQUANTITY;
}
