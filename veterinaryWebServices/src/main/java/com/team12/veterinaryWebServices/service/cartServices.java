package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.cartItemsDTO;
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
import com.team12.veterinaryWebServices.viewmodel.cartVM;
import com.team12.veterinaryWebServices.viewmodel.itemVM;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

        return cartVM.from(c);
    }

    public Object addItemToCart(itemDTO request){

        cart cart = cartRepository.getUserCart(request.getUserID());
        if(cart == null)
            return new appException(ERRORCODE.CART_DOES_NOT_EXIST);

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

            cartRepository.updateCartTotal(request.getCartID());
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
        cartRepository.updateCartTotal(request.getCartID());
        return itemVM.from(item);
    }

    public Object updateCart(cartDTO request){

        cart cart = cartRepository.getUserCart(request.getUserID());
        appException error = cartERROR(request,cart);

        if(error != null)
            return error;

        Object o = storageServices.checkCartStock(request);

        List<cartDetail> cartDetails = new ArrayList<>();

        for (cartItemsDTO i : ((cartDTO) o).getCartItems())
        {
            cartDetail cartItem = cartDetailRepository.getItemInCart(request.getCartID(), i.getItemCODE(), i.getItemID());
            cartItem.setItemQUANTIY(i.getItemQUANTITY());
            cartDetails.add(cartItem);
        }

        cart.setCartDetails(cartDetails);
        cartRepository.save(cart);
        cartRepository.updateCartTotal(request.getCartID());

        return cartVM.from(cart);
    }

    public Object deleteItemInCart(itemDTO request){
        cart cart = cartRepository.getUserCart(request.getUserID());
        if(cart == null)
            return new appException(ERRORCODE.CART_DOES_NOT_EXIST);

        if (!Objects.equals(cart.getCartID(), request.getCartID()))
            return new appException(ERRORCODE.NOT_CART_OWNER);

        cartDetail cD = cartDetailRepository.getItemInCart(request.getCartID(), request.getItemCODE(), request.getItemID());
        cartDetailRepository.delete(cD);
        cartRepository.updateCartTotal(request.getCartID());

        return cartVM.from(cart);
    }
}
