package com.team12.veterinaryWebServices.model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@IdClass(import_export.importExportCK.class)
@Table(name = "import_export")
public class import_export {

    @Id
    @Column(name = "importExportCODE")
    private String importExportCODE;

    @Id
    @Column(name = "importExportID")
    private Long importExportID;

    public static class importExportCK implements Serializable {

        private String importExportCODE;

        private Long importExportID;

        public importExportCK(String importExportCODE,Long importExportID){
            this.importExportCODE = importExportCODE;
            this.importExportID = importExportID;
        }
    }

    @ManyToOne
    @JoinColumns(
            {
                    @JoinColumn(name = "itemCODE", referencedColumnName = "itemCODE"),
                    @JoinColumn(name = "itemID", referencedColumnName = "itemID")
            }
    )
    private storage storage;

    @Column(name = "importExportPRICE")
    private int importExportPRICE;

    @Column(name = "importExportQUANTITY")
    private int getImportExportQUANTITY;
}
