package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.SequenceGenerator;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class Discount {

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
    private Integer discountId;

    @Column(length = 100)
    private String discountName;

    @Column(columnDefinition = "varchar(max)")
    private String description;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime startDate;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime endDate;

    @Column(precision = 7, scale = 2)
    private BigDecimal discountRate;

    @Column
    private Boolean display;

    @OneToMany(mappedBy = "discount")
    private Set<ProductDiscount> discountProductDiscounts;

    @OneToMany(mappedBy = "discount")
    private Set<CategoryDiscount> discountCategoryDiscounts;

    @OneToMany(mappedBy = "discount")
    private Set<SubCategoryDiscount> discountSubCategoryDiscounts;

}
