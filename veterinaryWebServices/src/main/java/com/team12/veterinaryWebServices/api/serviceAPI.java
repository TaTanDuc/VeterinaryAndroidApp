package com.team12.veterinaryWebServices.api;

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
        List<serviceVM> all = serviceServices.getAllServices();

        if (all.isEmpty())
            return ResponseEntity.ok("There is no service yet!");

        return ResponseEntity.ok(all);
    }

    @GetMapping("/comments")
    public ResponseEntity<Object> getServiceComments(@RequestParam("serviceCODE") String serviceCODE){
        List<commentVM> all = serviceServices.getServiceComments(serviceCODE);

        if (all.isEmpty())
            return ResponseEntity.ok("There is no comment yet!");

        return ResponseEntity.ok(all);
    }
}
