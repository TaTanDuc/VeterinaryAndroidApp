package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.service;

import java.util.List;

@Repository
public interface serviceRepository extends JpaRepository<service, Long> {

    @Query(value = "SELECT COALESCE(AVG(c.commentrating),0) FROM comment c WHERE c.servicecode = ?1", nativeQuery = true)
    double averageServiceRating (String serviceCODE);

    @Query(value = "SELECT s.* FROM service s WHERE s.servicecode = ?1", nativeQuery = true)
    service getService(String serviceCODE);
}
