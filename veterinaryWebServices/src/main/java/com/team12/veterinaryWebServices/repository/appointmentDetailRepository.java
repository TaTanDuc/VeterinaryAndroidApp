package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.appointmentDetail;
import com.team12.veterinaryWebServices.model.compositeKey.appointmentDetailCK;

@Repository
public interface appointmentDetailRepository extends JpaRepository<appointmentDetail, appointmentDetailCK> {
}
