package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.storage;
import com.team12.veterinaryWebServices.model.compositeKey.storageCK;

@Repository
public interface storageRepository extends JpaRepository<storage, storageCK> {
}
