package com.team12.veterinaryWebServices.model.compositeKey;

import com.team12.veterinaryWebServices.model.invoice;
import com.team12.veterinaryWebServices.model.storage;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
public class buyDetailCK implements Serializable {

    private invoice invoice;
    private Long buyDetailID;

    public buyDetailCK(invoice invoice,Long buyDetailID){
        this.invoice = invoice;
        this.buyDetailID = buyDetailID;
    }
}
