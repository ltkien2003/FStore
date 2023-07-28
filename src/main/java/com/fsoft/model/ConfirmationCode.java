package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import java.time.OffsetDateTime;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class ConfirmationCode {

    @Id
    @Column(nullable = false, updatable = false, length = 100)
    private String otpcode;

    @Column
    private Boolean isConfirmed;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime otpcreationDate;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime otpexpirationDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

}
