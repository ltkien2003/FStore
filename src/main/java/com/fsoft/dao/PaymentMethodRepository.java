package com.fsoft.dao;

import com.fsoft.model.PaymentMethod;
import org.springframework.data.jpa.repository.JpaRepository;


public interface PaymentMethodRepository extends JpaRepository<PaymentMethod, Integer> {
}
