package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.dto.itemDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.model.compositeKey.storageCK;

import java.util.List;

@Repository
public interface storageRepository extends JpaRepository<storage, storageCK> {

    @Query(value = "SELECT * FROM storage WHERE itemname LIKE '%?1%'",nativeQuery = true)
    List<storage> getAllByItemName (String itemNAME);

    @Query(value = "SELECT storage.instock FROM storage WHERE storage.itemcode = ?1 AND storage.itemID = ?2",nativeQuery = true)
    long getItemStock (String itemCODE, Long itemID);

    @Query(value = "SELECT * FROM storage WHERE (storage.itemcode, storage.itemid) IN ?1",nativeQuery = true)
    List<storage> getAllItem (List<itemDTO> items);

    @Query(value = "SELECT storage.* FROM storage WHERE (storage.itemcode, storage.itemid) IN ?1",nativeQuery = true)
    storage getItem (itemDTO item);
}
