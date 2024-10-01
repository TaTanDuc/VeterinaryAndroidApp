package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.service.storageServices;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/storage")
public class storageAPI {

    private final storageServices storageServices;

    @GetMapping("/getAllItems")
    public ResponseEntity<Object> getAllItems (){
        Object o = storageServices.getAllItem();
        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
        return ResponseEntity.ok(o);
    }

    @GetMapping("/search")
    public ResponseEntity<Object> searchItemsByName (@RequestParam ("itemName") String itemNAME){
        Object o = storageServices.findItemsByName(itemNAME);
        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
        return ResponseEntity.ok(o);
    }

    @GetMapping("/getItem")
    public ResponseEntity<Object> getItem (@RequestBody itemDTO requestITEM){
        Object o = storageServices.getItem(requestITEM);
        if (o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
        return ResponseEntity.ok(o);
    }
}
