package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.profile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface userRepository extends JpaRepository<profile, Long> {
    @Query(nativeQuery = true)
    Optional<profile> findUserByEmail (String email);
    @Query(nativeQuery = true)
    Optional<profile> findUserByUsername (String username);
}
