package com.fsoft.dao;

import com.fsoft.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ReviewRepository extends JpaRepository<Review, Integer> {
}
