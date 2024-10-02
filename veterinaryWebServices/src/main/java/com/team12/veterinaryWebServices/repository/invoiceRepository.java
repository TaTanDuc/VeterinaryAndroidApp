package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.invoice;
import com.team12.veterinaryWebServices.model.compositeKey.invoiceCK;

import java.util.List;

@Repository
public interface invoiceRepository extends JpaRepository<invoice, invoiceCK> {

    @Query(value = "SELECT * FROM invoice WHERE invoicecode = ?1",nativeQuery = true)
    List<invoice> findAllByInvoiceCode(String invoiceCODE);

    @Query(value = "SELECT COUNT(*) FROM invoice WHERE invoicecode = ?1",nativeQuery = true)
    long countByCode(String invoiceCODE);
}
