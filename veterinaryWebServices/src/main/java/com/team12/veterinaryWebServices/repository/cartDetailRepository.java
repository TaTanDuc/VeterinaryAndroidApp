package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.cartDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface cartDetailRepository extends JpaRepository<cartDetail, Long> {

    @Query(value = "SELECT cd.* FROM cart_detail cd WHERE cd.cartid = ?1 AND cd.itemcode = ?2 AND cd.itemid = ?3", nativeQuery = true)
    cartDetail getItemInCart (Long cartID, String itemCODE, Long itemID);
}
