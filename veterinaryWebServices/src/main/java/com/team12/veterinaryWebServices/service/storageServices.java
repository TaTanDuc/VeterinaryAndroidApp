package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.cartItemsDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.compositeKey.storageCK;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.repository.profileRepository;
import com.team12.veterinaryWebServices.repository.storageRepository;
import com.team12.veterinaryWebServices.viewmodel.itemVM;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class storageServices {

    private final storageRepository storageRepository;

    public Object getAllItem(){
        List<storage> items = storageRepository.findAll();

        if(items.isEmpty())
            return new appException(ERRORCODE.NO_ITEM_FOUND);

        return items.stream().map(itemVM::from).toList();
    }

    public Object findItemsByName(String itemNAME){
        List<storage> items = storageRepository.getAllByItemName(itemNAME);

        if(items.isEmpty())
            return new appException(ERRORCODE.NO_ITEM_FOUND);

        return items.stream().map(itemVM::from).toList();
    }

    public Object getItem(itemDTO request){
        storage item = storageRepository.getItem(request.getItemCODE(), request.getItemID());

        if (item == null)
            return new appException(ERRORCODE.NO_ITEM_FOUND);

        return itemVM.from(item);
    }

    public Object getItemByCategory(String category){
        List<storage> item = storageRepository.getItemByCategory(category);

        if (item.isEmpty())
            return new appException(ERRORCODE.NO_ITEM_FOUND);

        return item.stream().map(itemVM::from).toList();
    }

    public Object checkItemStock(itemDTO item){
        storage result = storageRepository.getItem(item.getItemCODE(), item.getItemID());

        if (result.getINSTOCK() == 0)
            return ERRORCODE.SOLD_OUT;
        if (result.getINSTOCK() < item.getQuantity())
            return ERRORCODE.ITEM_OVER_STOCK;
        return result;
    }

    public Object checkCartStock(cartDTO cart){

        for (cartItemsDTO i : cart.getCartItems())
        {
            storage item = storageRepository.getItem(i.getItemCODE(),i.getItemID());
            if (item.getINSTOCK() < i.getItemQUANTITY())
                i.setItemQUANTITY(1);
            if (item.getINSTOCK() <= 0)
                i.setItemQUANTITY(0);
        }

        return cart;
    }
}
