package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.model.compositeKey.storageCK;

import java.util.List;

@Repository
public interface storageRepository extends JpaRepository<storage, storageCK> {

    @Query(value = "SELECT * FROM storage WHERE storage.itemcategory = ?1 AND storage.itemname LIKE %?2%",nativeQuery = true)
    List<storage> getAllByItemNameAndCategory (String itemCATEGORY , String itemNAME);

    @Query(value = "SELECT storage.* FROM storage WHERE storage.itemcode = ?1 AND storage.itemid = ?2",nativeQuery = true)
    storage getItem (String itemCODE, Long itemID);

    @Query(value = "SELECT * FROM storage WHERE storage.itemcategory = ?1",nativeQuery = true)
    List<storage> getItemByCategory (String category);

    @Query(value = "SELECT * FROM storage WHERE storage.itemcode = 'NULL'",nativeQuery = true)
    storage getNull();

    @Query(value = "SELECT * FROM storage WHERE storage.itemcode not in ('NULL') ORDER BY RAND() LIMIT 3",nativeQuery = true)
    List<storage> get3Random();
}
