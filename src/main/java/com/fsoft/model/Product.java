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
import java.time.OffsetDateTime;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;


@Entity
@Getter
@Setter
public class Product {

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
    private Integer productId;

    @Column(length = 100)
    private String productName;

    @Column(columnDefinition = "varchar(max)")
    private String description;

    @Column(length = 100)
    private String origin;

    @Column
    private Double price;

    @Column
    private Integer viewCount;

    @Column
    private Boolean available;

    @Column
    private Boolean featured;

    @Column
    private Boolean display;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime createdDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_category_id")
    private ProductCategory productCategory;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sub_category_id")
    private SubCategory subCategory;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "product")
    private Set<DirectDiscount> productDirectDiscounts;

    @OneToMany(mappedBy = "product")
    private Set<Color> productColors;

    @OneToMany(mappedBy = "product")
    private Set<ProductDetail> productProductDetails;

    @OneToMany(mappedBy = "product")
    private Set<LaptopConfiguration> productLaptopConfigurations;

    @OneToMany(mappedBy = "product")
    private Set<PhoneConfiguration> productPhoneConfigurations;

    @OneToMany(mappedBy = "product")
    private Set<OrderDetail> productOrderDetails;

    @OneToMany(mappedBy = "product")
    private Set<Review> productReviews;

    @OneToMany(mappedBy = "product")
    private Set<ProductImage> productProductImages;

    @OneToMany(mappedBy = "product")
    private Set<ImportReceiptDetail> productImportReceiptDetails;

    @OneToMany(mappedBy = "product")
    private Set<CartDetail> productCartDetails;

    @OneToMany(mappedBy = "product")
    private Set<ProductDiscount> productProductDiscounts;

}
