package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.team12.veterinaryWebServices.model.profile;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface profileRepository extends JpaRepository<profile,Long> {

    @Query(value = "SELECT profile.* FROM profile WHERE profile.username = ?1 OR profile.email = ?2", nativeQuery = true)
    profile getByEmailOrUsername(String username, String email);

    @Query(value = "SELECT profile.* FROM profile WHERE profileid = ?1", nativeQuery = true)
    profile getProfileById(Long profileID);
}
