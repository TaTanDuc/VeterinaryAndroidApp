package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.service.cartServices;
import com.team12.veterinaryWebServices.viewmodel.cartVM;
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
    public ResponseEntity<Object> addItemToUserCart(@RequestBody itemDTO request){
        Object o = cartServices.addItemToCart(request);

        if(o instanceof appException e)
            return new ResponseEntity<>(e.getMessage(),e.getErrorCode());

        return ResponseEntity.ok(o);
    }

    @PutMapping("/updateCart")
    public ResponseEntity<Object> updateUserCart(@RequestBody cartDTO request){
        Object o = cartServices.up

        return ResponseEntity.ok(o);+
    }
}
