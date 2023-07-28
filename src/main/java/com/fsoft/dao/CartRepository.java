package com.fsoft.dao;

import com.fsoft.model.Cart;
import org.springframework.data.jpa.repository.JpaRepository;


public interface CartRepository extends JpaRepository<Cart, Integer> {
}
