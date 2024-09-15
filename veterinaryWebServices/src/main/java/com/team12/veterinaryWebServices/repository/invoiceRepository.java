package com.team12.veterinaryWebServices.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.team12.veterinaryWebServices.model.invoice;
import com.team12.veterinaryWebServices.model.compositeKey.invoiceCK;

@Repository
public interface invoiceRepository extends JpaRepository<invoice, invoiceCK> {
}
