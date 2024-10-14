package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.cart;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface cartRepository extends JpaRepository<cart, Long> {

    @Query(value = "SELECT cart.* FROM cart WHERE cart.profileid = ?1",nativeQuery = true)
    cart getUserCart (Long userID);

    @Transactional
    @Modifying
    @Query(value = "UPDATE cart SET cart.total = (SELECT SUM(s.itemprice * cd.itemquantity) FROM cart_detail cd, storage s WHERE cd.itemcode = s.itemcode AND cd.itemid = s.itemid AND cd.cartid = ?1)",nativeQuery = true)
    void updateCartTotal(Long cartID);
}
