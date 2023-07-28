package com.fsoft.dao;

import com.fsoft.model.LoginActivity;
import org.springframework.data.jpa.repository.JpaRepository;


public interface LoginActivityRepository extends JpaRepository<LoginActivity, Integer> {
}
