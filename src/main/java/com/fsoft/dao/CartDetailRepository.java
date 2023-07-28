package com.fsoft.dao;

import com.fsoft.model.CartDetail;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CartDetailRepository extends JpaRepository<CartDetail, Integer> {
}
