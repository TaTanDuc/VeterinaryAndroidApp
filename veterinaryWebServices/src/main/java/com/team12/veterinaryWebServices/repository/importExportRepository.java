package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.import_export;

@Repository
public interface importExportRepository extends JpaRepository<import_export, Long> {
}
