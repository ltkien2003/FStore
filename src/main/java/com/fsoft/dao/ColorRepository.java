package com.fsoft.dao;

import com.fsoft.model.Color;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ColorRepository extends JpaRepository<Color, Integer> {
}
