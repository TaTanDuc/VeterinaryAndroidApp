package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.service.invoiceServices;
import com.team12.veterinaryWebServices.viewmodel.invoiceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/invoice")
public class invoiceAPI {

    private final invoiceServices invoiceServices;

    @GetMapping("/all")
    public ResponseEntity<List<invoiceVM>> allInvoices(){
        return ResponseEntity.ok(invoiceServices.getAllInvoices());
    }

    @GetMapping("/buy")
    public ResponseEntity<List<invoiceVM.buy>> allBuyInvoices(){
        return ResponseEntity.ok(invoiceServices.getAllBuyInvoices());
    }

    @GetMapping("/appointment")
    public ResponseEntity<List<invoiceVM.appointment>> allAppointmentInvoices(){
        return ResponseEntity.ok(invoiceServices.getAllAppointmentInvoices());
    }
}
