package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface commentRepository extends JpaRepository<comment, Long>{
    @Query(value = "SELECT * FROM comment c WHERE c.servicecode = ?1 ORDER BY c.commentdate DESC",nativeQuery = true)
    List<comment> getComments(String serviceCODE);

    @Query(value = "SELECT * FROM comment c WHERE c.servicecode = ?1 ORDER BY c.commentdate DESC LIMIT 3",nativeQuery = true)
    List<comment> getRecentComments(String serviceCODE);
}
