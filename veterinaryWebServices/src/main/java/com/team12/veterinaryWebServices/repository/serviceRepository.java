package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.service;

@Repository
public interface serviceRepository extends JpaRepository<service, Long> {

    @Query(value = "SELECT COALESCE(AVG(c.commentrating),0) FROM comment c WHERE c.servicecode = ?1", nativeQuery = true)
    double averageServiceRating (String serviceCODE);

}
