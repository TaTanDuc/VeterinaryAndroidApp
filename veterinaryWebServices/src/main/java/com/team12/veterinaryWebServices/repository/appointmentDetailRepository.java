package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.appointmentDetail;

@Repository
public interface appointmentDetailRepository extends JpaRepository<appointmentDetail, Long> {
}
