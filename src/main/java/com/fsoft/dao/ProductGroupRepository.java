package com.fsoft.dao;

import com.fsoft.model.ProductGroup;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProductGroupRepository extends JpaRepository<ProductGroup, Integer> {
}
