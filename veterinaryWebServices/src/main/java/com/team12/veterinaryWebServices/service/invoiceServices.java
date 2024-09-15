package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.repository.invoiceRepository;
import com.team12.veterinaryWebServices.viewmodel.invoiceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class invoiceServices {
    
    private final invoiceRepository invoiceRepository;

    public List<invoiceVM> getAllInvoices (){
        return invoiceRepository.findAll()
                .stream()
                .map(invoiceVM::from)
                .toList();
    }

    public List<invoiceVM.buy> getAllBuyInvoices (){
        return invoiceRepository.findAllByInvoiceCode("B")
                .stream()
                .map(invoiceVM.buy::from)
                .toList();
    }

    public List<invoiceVM.appointment> getAllAppointmentInvoices (){
        return invoiceRepository.findAllByInvoiceCode("A")
                .stream()
                .map(invoiceVM.appointment::from)
                .toList();
    }
}
