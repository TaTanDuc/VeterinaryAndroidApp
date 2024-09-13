package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@Entity
@IdClass(storage.itemCK.class)
@Table(name = "storage")
public class storage {

    @Id
    @Column(name = "itemCODE")
    private String itemCODE;

    @Id
    @Column(name = "itemID")
    private Long itemID;

    public static class itemCK implements Serializable {

        private String itemCODE;

        private Long itemID;

        public itemCK(String storageCODE,Long storageID){
            this.itemCODE = storageCODE;
            this.itemID = storageID;
        }
    }

    @Column(name = "itemNAME")
    private String itemNAME;

    @Column(name = "itemPRICE")
    private int itemPRICE;

    @Column(name = "INSTOCK")
    private int INSTOCK;

    @OneToMany(mappedBy = "storage")
    private List<appointmentDetail> appointmentDetails;

    @OneToMany(mappedBy = "storage")
    private List<buyDetail> buyDetails;

    @OneToMany(mappedBy = "storage")
    private List<import_export> importExports;

}
