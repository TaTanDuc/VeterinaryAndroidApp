package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.invoiceServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/invoice")
public class invoiceAPI {

    private final invoiceServices invoiceServices;

    @GetMapping("/all")
    public ResponseEntity<Object> allInvoices(){
        Object o = invoiceServices.getAllInvoices();

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/buy")
    public ResponseEntity<Object> allBuyInvoices(){
        Object o = invoiceServices.getAllBuyInvoices();

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/appointment")
    public ResponseEntity<Object> allAppointmentInvoices(){
        Object o = invoiceServices.getAllAppointmentInvoices();

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/getUserInvoices")
    public ResponseEntity<Object> getUserInvoices(@RequestParam("userID") Long request){
        Object o = invoiceServices.getAllUserInvoices(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
