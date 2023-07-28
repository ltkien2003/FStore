package com.fsoft.dao;

import com.fsoft.model.ProductImage;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProductImageRepository extends JpaRepository<ProductImage, Integer> {
}
