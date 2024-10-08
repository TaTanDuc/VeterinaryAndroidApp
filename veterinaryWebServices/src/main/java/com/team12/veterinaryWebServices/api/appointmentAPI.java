package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.appointmentDTO;
import com.team12.veterinaryWebServices.exception.appException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.team12.veterinaryWebServices.service.appointmentServices;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/appointment")
public class appointmentAPI {

    private final appointmentServices appointmentServices;

    @GetMapping("/all")
    public ResponseEntity<Object> allAppointments(){
        Object o = appointmentServices.getAllAppointments();

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/getWeek")
    public ResponseEntity<Object> getWeek(){
        Object o = appointmentServices.getWeekAppointments();

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/getUserAppointment")
    public ResponseEntity<Object> getUserAppointment(@RequestParam("userID") Long userID){
        Object o = appointmentServices.getUserAppointment(userID);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @PostMapping("/add")
    public ResponseEntity<Object> addAppointment(@RequestBody appointmentDTO request){
        appException e = appointmentServices.addAppointment(request);
        return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
    }
}
