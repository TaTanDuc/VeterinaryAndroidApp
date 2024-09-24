package com.team12.veterinaryWebServices.viewmodel;

import com.team12.veterinaryWebServices.model.invoice;
import java.sql.Date;
import java.util.List;

public record invoiceVM(String invoiceCODE, Long invoiceID, Date invoiceDATE, Long total) {

    public static invoiceVM from (invoice i){

        return new invoiceVM(
                i.getInvoiceCODE(),
                i.getInvoiceID(),
                i.getInvoiceDATE(),
                i.getTOTAL()
        );
    }

    public record buy (String invoiceCODE, Long invoiceID, Date invoiceDATE, List<bDetails> buyDetails, Long total){
        public static buy from (invoice i){

            List<bDetails> buyDetails = i.getBuyDetail()
                    .stream()
                    .map(bD -> new bDetails(
                            bD.getStorage().getItemNAME(),
                            bD.getStorage().getItemPRICE(),
                            bD.getItemQUANTITY()
                    )
                    ).toList();

            return new buy(
                    i.getInvoiceCODE(),
                    i.getInvoiceID(),
                    i.getInvoiceDATE(),
                    buyDetails,
                    i.getTOTAL()
            );
        }
    }

    public record appointment (String invoiceCODE, Long invoiceID, Date invoiceDATE, List<apmDetails> appointmentDetails, Long total){
        public static appointment from (invoice i){

            List<apmDetails> appointmentDetails = i.getAppointmentDetails()
                    .stream()
                    .map(aD -> new apmDetails(
                            aD.getService().getServiceNAME(),
                            aD.getService().getServicePRICE(),
                            aD.getStorage().getItemNAME(),
                            aD.getStorage().getItemPRICE(),
                            aD.getItemQUANTITY()
                    )
                    ).toList();

            return new appointment(
                    i.getInvoiceCODE(),
                    i.getInvoiceID(),
                    i.getInvoiceDATE(),
                    appointmentDetails,
                    i.getTOTAL()
            );
        }
    }

    private record apmDetails (String serviceNAME, Long servicePRICE, String itemNAME, Long itemPRICE, Long itemQUANTITY) {}

    private record bDetails (String itemNAME, Long itemPRICE, Long itemQUANTITY) {}
}
