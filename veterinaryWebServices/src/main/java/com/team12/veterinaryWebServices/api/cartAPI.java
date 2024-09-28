package com.team12.veterinaryWebServices.api;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.service.cartServices;
import com.team12.veterinaryWebServices.viewmodel.cartVM;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

}
