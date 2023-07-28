package com.fsoft.dao;

import com.fsoft.model.ConfirmationCode;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ConfirmationCodeRepository extends JpaRepository<ConfirmationCode, String> {
}
