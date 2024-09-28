package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface cartRepository extends JpaRepository<cart, Long> {

    @Query(value = "SELECT cart.* FROM cart WHERE cart.profileid = ?1",nativeQuery = true)
    cart getUserCart (Long userID);
}
