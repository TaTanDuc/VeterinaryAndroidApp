package com.team12.veterinaryWebServices.service;

import com.team12.veterinaryWebServices.dto.cartDTO;
import com.team12.veterinaryWebServices.dto.itemDTO;
import com.team12.veterinaryWebServices.exception.ERRORCODE;
import com.team12.veterinaryWebServices.exception.appException;
import com.team12.veterinaryWebServices.model.compositeKey.storageCK;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.repository.storageRepository;
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

    private appException storageERROR(List<storage> items){
        if(items.isEmpty())
            return new appException(ERRORCODE.NO_ITEM_FOUND);
        return null;
    }

    public Object getAllItem(){
        List<storage> items = storageRepository.findAll();
        appException error = storageERROR(items);

        if (error != null)
            return error;

        return items;
    }

    public Object findItemByName(String itemNAME){
        List<storage> items = storageRepository.getAllByItemName(itemNAME);
        appException error = storageERROR(items);

        if (error != null)
            return error;

        return items;
    }

    public Object checkItemStock(itemDTO item){
        long result = storageRepository.getItemStock(item.getItemCODE(), item.getItemID());

        if (result == 0)
            return new appException(ERRORCODE.SOLD_OUT);
        if (result < item.getQUANTITY())
            return new appException(ERRORCODE.ITEM_OVER_STOCK);
        return null;
    }

    public Object checkItemsStock(List<itemDTO> items){
        List<storage> list = storageRepository.getAllItem(items);

        Map<storageCK, storage> itemMap = list
                .stream()
                .collect(Collectors.toMap(storage -> new storageCK(storage.getItemCODE(),storage.getItemID()), storage -> storage));

        List<appException> errorList = new ArrayList<>();

        for (itemDTO i : items){
            storageCK key = new storageCK(i.getItemCODE(),i.getItemID());
            storage item = itemMap.get(key);

            if (item == null)
                errorList.add(new appException(ERRORCODE.NO_ITEM_FOUND));
            else if (item.getINSTOCK() == 0)
                errorList.add(new appException(ERRORCODE.SOLD_OUT));
            else if (i.getQUANTITY() > item.getINSTOCK())
                errorList.add(new appException(ERRORCODE.ITEM_OVER_STOCK));
        }

        return errorList;
    }
}
