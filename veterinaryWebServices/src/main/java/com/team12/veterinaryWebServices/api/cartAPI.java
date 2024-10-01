package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.service.cartServices;
import com.team12.veterinaryWebServices.viewmodel.cartVM;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/cart")
public class cartAPI {

    private final cartServices cartServices;

    @GetMapping("/getUserCart")
    public ResponseEntity<Object> getUserCart(@RequestBody cartDTO request){
        Object o = cartServices.getUserCart(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(cartVM.from((cart) o));
    }

    @PostMapping("/addItem")
    public ResponseEntity<Object> addItemToCart(@RequestBody itemDTO requestITEM,
                                                @RequestBody cartDTO requestCART){
        appException e = ((appException) cartServices.addItemToCart(requestITEM, requestCART));

        return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
    }

    @PostMapping("/cartCheckOut")
    public ResponseEntity<Object> cartCheckOut(@RequestBody List<itemDTO> requestITEMs,
                                               @RequestBody cartDTO requestCART){
        
        appException e = (appException) cartServices.cartCheckOut(requestITEMs,requestCART);

        return new ResponseEntity<>(e.getMessage(),e.getErrorCode());
    }

}
