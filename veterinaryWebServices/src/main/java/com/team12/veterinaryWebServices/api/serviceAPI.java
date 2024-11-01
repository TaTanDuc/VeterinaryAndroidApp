package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.commentDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.serviceServices;
import com.team12.veterinaryWebServices.viewmodel.commentVM;
import com.team12.veterinaryWebServices.viewmodel.serviceVM;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/comments")
    public ResponseEntity<Object> getServiceComments(@RequestParam("serviceCODE") String serviceCODE){
        Object o = serviceServices.getServiceComments(serviceCODE);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @GetMapping("/overallRating")
    public ResponseEntity<Object> getOverallRating(@RequestParam("serviceCODE") String serviceCODE){
        Object o = serviceServices.getOverallRating(serviceCODE);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @PostMapping("/addComment")
    public ResponseEntity<Object> addComment(@RequestBody commentDTO request){
        Object o = serviceServices.addComment(request);

        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }
}
