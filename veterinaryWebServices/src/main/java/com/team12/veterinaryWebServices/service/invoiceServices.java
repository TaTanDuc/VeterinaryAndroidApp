package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.invoice;
import com.team12.veterinaryWebServices.repository.invoiceRepository;
import com.team12.veterinaryWebServices.viewmodel.invoiceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class invoiceServices {
    
    private final invoiceRepository invoiceRepository;

    public Object getAllInvoices (){
        List<invoice> list = invoiceRepository.findAll();

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_INVOICE_FOUND);

        return list.stream().map(invoiceVM::from).toList();
    }

    public Object getAllBuyInvoices (){
        List<invoice> list = invoiceRepository.findAllByInvoiceCode("B");

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_INVOICE_FOUND);

        return list.stream().map(invoiceVM.buy::from).toList();
    }

    public Object getAllAppointmentInvoices (){
        List<invoice> list = invoiceRepository.findAllByInvoiceCode("A");

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_INVOICE_FOUND);

        return list.stream().map(invoiceVM.appointment::from).toList();
    }

    public Object getAllUserInvoices (Long userID){
        List<invoice> list = invoiceRepository.getUserInvoices(userID);

        if(list.isEmpty())
            return new appException(ERRORCODE.NO_INVOICE_FOUND);

        return list.stream().map(invoiceVM::from).toList();
    }
}
