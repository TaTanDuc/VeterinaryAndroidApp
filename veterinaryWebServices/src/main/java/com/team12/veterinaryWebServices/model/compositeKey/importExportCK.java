package com.team12.veterinaryWebServices.model.compositeKey;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class importExportCK implements Serializable {

    private String importExportCODE;
    private Long importExportID;

    public importExportCK(String importExportCODE,Long importExportID){
        this.importExportCODE = importExportCODE;
        this.importExportID = importExportID;
    }
}