package com.team12.veterinaryWebServices.model;

import com.team12.veterinaryWebServices.model.compositeKey.importExportCK;
import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Entity
@Data
@IdClass(importExportCK.class)
@Table(name = "import_export")
public class import_export {

    @Id
    @Column(name = "importExportCODE")
    private String importExportCODE;

    @Id
    @Column(name = "importExportID")
    private Long importExportID;

    @ManyToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "itemCODE", referencedColumnName = "itemCODE"),
                    @JoinColumn(name = "itemID", referencedColumnName = "itemID")
            }
    )
    private storage storage;

    @Column(name = "importExportPRICE")
    private Long importExportPRICE;

    @Column(name = "importExportQUANTITY")
    private Long getImportExportQUANTITY;
}
