package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.pet;

import java.util.List;

@Repository
public interface petRepository extends JpaRepository<pet, Long> {

    @Query(value = "SELECT * FROM pet WHERE profileid = ?1", nativeQuery = true)
    List<pet> getProfilePets(Long profileID);

    @Query(value = "SELECT pet.* FROM pet WHERE petid = ?1", nativeQuery = true)
    pet getPetById(Long petID);
}
