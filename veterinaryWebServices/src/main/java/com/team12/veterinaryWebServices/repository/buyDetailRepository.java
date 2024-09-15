package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.buyDetail;
import com.team12.veterinaryWebServices.model.compositeKey.buyDetailCK;

@Repository
public interface buyDetailRepository extends JpaRepository<buyDetail, buyDetailCK> {
}
