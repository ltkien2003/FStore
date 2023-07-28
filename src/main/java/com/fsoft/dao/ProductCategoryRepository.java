package com.fsoft.dao;

import com.fsoft.model.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProductCategoryRepository extends JpaRepository<ProductCategory, Integer> {
}
