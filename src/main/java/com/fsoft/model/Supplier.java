package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.SequenceGenerator;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class Supplier {

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
    private Integer supplierId;

    @Column(length = 100)
    private String supplierName;

    @Column(length = 100)
    private String businessName;

    @Column(length = 20)
    private String phoneNumber;

    @Column(length = 100)
    private String email;

    @Column
    private Boolean display;

    @OneToMany(mappedBy = "supplier")
    private Set<ImportReceipt> supplierImportReceipts;

}
