package com.team12.veterinaryWebServices.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.team12.veterinaryWebServices.service.appointmentServices;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/appointment")
public class appointmentAPI {

    private final appointmentServices appointmentServices;

    @GetMapping("/all")
    public ResponseEntity<Object> allAppointments(){
        return ResponseEntity.ok(appointmentServices.getAllAppointments());
    }
}
