package com.team12.veterinaryWebServices.model.compositeKey;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class invoiceCK implements Serializable {

    private String invoiceCODE;
    private Long invoiceID;

    public invoiceCK(String invoiceCODE,Long invoiceID){
        this.invoiceCODE = invoiceCODE;
        this.invoiceID = invoiceID;
    }
}
