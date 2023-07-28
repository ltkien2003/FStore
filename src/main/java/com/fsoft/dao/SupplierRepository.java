package com.fsoft.dao;

import com.fsoft.model.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;


public interface SupplierRepository extends JpaRepository<Supplier, Integer> {
}
