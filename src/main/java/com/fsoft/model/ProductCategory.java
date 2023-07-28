package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.SequenceGenerator;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class ProductCategory {

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
    private Integer productCategoryId;

    @Column(length = 100)
    private String productCategoryName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_group_id")
    private ProductGroup productGroup;

    @OneToMany(mappedBy = "productCategory")
    private Set<SubCategory> productCategorySubCategorys;

    @OneToMany(mappedBy = "productCategory")
    private Set<Product> productCategoryProducts;

    @OneToMany(mappedBy = "productCategory")
    private Set<CategoryDiscount> productCategoryCategoryDiscounts;

}
