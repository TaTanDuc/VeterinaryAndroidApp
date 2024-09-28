package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.cartDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface cartDetailRepository extends JpaRepository<cartDetail, Long> {
}
