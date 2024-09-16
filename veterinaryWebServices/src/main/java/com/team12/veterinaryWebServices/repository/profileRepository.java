package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.team12.veterinaryWebServices.model.profile;
import org.springframework.stereotype.Repository;

@Repository
public interface profileRepository extends JpaRepository<profile,Long> {

    boolean existByEmail (String email);
    boolean existByUsername (String username);
}
