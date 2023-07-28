package com.fsoft.dao;

import com.fsoft.model.ProductDiscount;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProductDiscountRepository extends JpaRepository<ProductDiscount, Integer> {
}
