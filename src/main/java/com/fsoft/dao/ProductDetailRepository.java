package com.fsoft.dao;

import com.fsoft.model.ProductDetail;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProductDetailRepository extends JpaRepository<ProductDetail, Integer> {
}
