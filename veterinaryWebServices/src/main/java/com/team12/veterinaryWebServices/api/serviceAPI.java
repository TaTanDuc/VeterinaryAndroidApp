package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.serviceServices;
import com.team12.veterinaryWebServices.viewmodel.commentVM;
import com.team12.veterinaryWebServices.viewmodel.serviceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/service")
public class serviceAPI {

    private final serviceServices serviceServices;

    @GetMapping("/all")
    public ResponseEntity<Object> getAllServices(){
        Object o = serviceServices.getAllServices();

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/detail")
    public ResponseEntity<Object> getServiceDetail(@RequestParam("serviceCODE") String serviceCODE){
        Object o = serviceServices.getServiceDetail(serviceCODE);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
