package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.model.profile;
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

    public Object addItemToCart(itemDTO item, cartDTO cart) {
        cart c = cartRepository.getUserCart(cart.getProfileID());
        appException error = cartERROR(cart,c);
        Object storageERROR = storageServices.checkItemStock(item);

        if(error != null)
            return error;
        if(storageERROR != null)
            return storageERROR;

        return new appException("Item added successfully!");
    }

    public Object cartCheckOut(List<itemDTO> list , cartDTO cart){
        Object storageERROR = storageServices.checkItemsStock(list);
        cart c = cartRepository.getUserCart(cart.getProfileID());
        appException error = cartERROR(cart,c);

        if(error != null)
            return error;
        if(storageERROR != null)
            return storageERROR;

        return new appException("Redirecting you to check out!");
    }
}
