package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import java.time.OffsetDateTime;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class IncorrectPasswordActivity {

    @Id
    @Column(nullable = false, updatable = false)
    @SequenceGenerator(
            name = "primary_sequence",
            sequenceName = "primary_sequence",
            allocationSize = 1,
            initialValue = 10000
    )
    @GeneratedValue(
            strategy = GenerationType.SEQUENCE,
            generator = "primary_sequence"
    )
    private Integer incorrectPasswordActivityId;

    @Column
    private Integer failedPasswordAttempts;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime lastFailedPasswordTime;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime accountLockTime;

    @Column(length = 50)
    private String ipaddress;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

}
