package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.petDetail;
import java.util.List;

@Repository
public interface petDetailRepository extends JpaRepository<petDetail, Long> {

    @Query(value = "SELECT * FROM pet_detail pd WHERE pd.petid = ?1 ORDER BY pd.pet_detaildate DESC", nativeQuery = true)
    List<petDetail> getPetDetails (Long petID);
}
