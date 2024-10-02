package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.repository.cartDetailRepository;
import com.team12.veterinaryWebServices.repository.cartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@RequiredArgsConstructor
@Service
public class cartServices {

    private final cartRepository cartRepository;
    private final storageServices storageServices;

    public void createUserCart(profile p){
        cart c = new cart();
        c.setProfile(p);
        cartRepository.save(c);
    }

    public appException cartERROR(cartDTO request, cart c){
        if(c == null)
            return new appException(ERRORCODE.USER_DOES_NOT_EXIST);
        if(!Objects.equals(c.getCartID(), request.getCartID()))
            return new appException(ERRORCODE.NOT_CART_OWNER);
        return null;
    }

    public Object getUserCart(cartDTO request) {
        cart c = cartRepository.getUserCart(request.getProfileID());
        appException error = cartERROR(request,c);

        if(error != null)
            return error;

        return c;
    }

    public Object addItemToCart(itemDTO request){
        Object o = storageServices.checkItemStock(request);

        if (!Objects.equals(cartRepository.getUserCart(request.getUserID()).getCartID(), request.getCartID()))
            return new appException(ERRORCODE.NOT_CART_OWNER);

        if (o instanceof ERRORCODE e)
            return new appException(e);

        return (storage) o;
    }

    public Object updateCart(cartDTO request){
        Object o = storageServices.


    }

}
