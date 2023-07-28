package com.fsoft.dao;

import com.fsoft.model.Discount;
import org.springframework.data.jpa.repository.JpaRepository;


public interface DiscountRepository extends JpaRepository<Discount, Integer> {
}
