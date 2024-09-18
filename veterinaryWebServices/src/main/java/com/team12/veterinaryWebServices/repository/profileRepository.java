package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.team12.veterinaryWebServices.model.profile;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface profileRepository extends JpaRepository<profile,Long> {

    @Query(nativeQuery = true)
    Optional<profile> findProfileByEmail (String email);
    @Query(nativeQuery = true)
    Optional<profile> findProfileByUsername (String username);
}
