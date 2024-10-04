package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.cart;
import com.team12.veterinaryWebServices.model.cartDetail;
import com.team12.veterinaryWebServices.model.profile;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.repository.cartDetailRepository;
import com.team12.veterinaryWebServices.repository.cartRepository;
import com.team12.veterinaryWebServices.repository.storageRepository;
import com.team12.veterinaryWebServices.viewmodel.itemVM;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@RequiredArgsConstructor
@Service
public class cartServices {

    private final cartRepository cartRepository;
    private final storageServices storageServices;
    private final cartDetailRepository cartDetailRepository;
    private final storageRepository storageRepository;

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
        cart c = cartRepository.getUserCart(request.getUserID());
        appException error = cartERROR(request,c);

        if(error != null)
            return error;

        return c;
    }

    public Object addItemToCart(itemDTO request){
        cart cart = cartRepository.getUserCart(request.getUserID());
        if (!Objects.equals(cart.getCartID(), request.getCartID()))
            return new appException(ERRORCODE.NOT_CART_OWNER);

        storage item = storageRepository.getItem(request.getItemCODE(), request.getItemID());

        cartDetail cartItem = cartDetailRepository.getItemInCart(request.getCartID(), request.getItemCODE(), request.getItemID());

        if (cartItem != null) {
            int tempQuantity = cartItem.getItemQUANTIY() + request.getQuantity();
            if (item.getINSTOCK() < tempQuantity)
            {
                cartItem.setItemQUANTIY(1);
                return new appException(ERRORCODE.ITEM_OVER_STOCK);
            }
            if (item.getINSTOCK() == 0)
            {
                cartItem.setItemQUANTIY(0);
                return new appException(ERRORCODE.ITEM_OVER_STOCK);
            }
            cartItem.setItemQUANTIY(tempQuantity);
            cartDetailRepository.save(cartItem);
            return itemVM.from(item);
        }

        if (item.getINSTOCK() == 0)
            return new appException(ERRORCODE.SOLD_OUT);
        if (item.getINSTOCK() < request.getQuantity())
            return new appException(ERRORCODE.ITEM_OVER_STOCK);

        cartDetail cartItems = new cartDetail();

        cartItems.setCart(cart);
        cartItems.setStorage(item);
        cartItems.setItemQUANTIY(request.getQuantity());

        cartDetailRepository.save(cartItems);
        return itemVM.from(item) ;
    }

    public Object updateCart(cartDTO request){
        Object o = storageServices.checkCartStock(request);

        if(o instanceof ERRORCODE e)
            return new appException(e);

        return o;
    }

}
