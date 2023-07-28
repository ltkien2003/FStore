package com.fsoft.dao;

import com.fsoft.model.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;


public interface OrderDetailRepository extends JpaRepository<OrderDetail, Integer> {
}
