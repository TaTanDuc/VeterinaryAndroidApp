package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.model.compositeKey.storageCK;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Data
@IdClass(storageCK.class)
@Table(name = "storage")
public class storage {

    @Id
    @Column(name = "itemCODE")
    private String itemCODE;

    @Id
    @Column(name = "itemID")
    private Long itemID;

    @Column(name = "itemNAME")
    private String itemNAME;

    @Column(name = "itemPRICE")
    private Long itemPRICE;

    @Column(name = "INSTOCK")
    private Long INSTOCK;

    @OneToMany(mappedBy = "storage")
    private List<appointmentDetail> appointmentDetails;

    @OneToMany(mappedBy = "storage")
    private List<buyDetail> buyDetails;

    @OneToMany(mappedBy = "storage")
    private List<import_export> importExports;

    @OneToMany(mappedBy = "storage")
    private List<cartDetail> cartDetails;

}
