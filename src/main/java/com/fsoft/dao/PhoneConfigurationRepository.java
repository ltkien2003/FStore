package com.fsoft.dao;

import com.fsoft.model.PhoneConfiguration;
import org.springframework.data.jpa.repository.JpaRepository;


public interface PhoneConfigurationRepository extends JpaRepository<PhoneConfiguration, Integer> {
}
