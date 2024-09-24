package com.team12.veterinaryWebServices.repository;

import com.team12.veterinaryWebServices.model.comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface commentRepository extends JpaRepository<comment, Long> {

    @Query(value = "SELECT * FROM comment WHERE comment.servicecode = ?1 ORDER BY comment.commentdate", nativeQuery = true)
    List<comment> getServiceComments(String serviceCODE);
}
