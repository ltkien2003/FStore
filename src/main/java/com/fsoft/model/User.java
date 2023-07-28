package com.fsoft.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;


@Entity
@Table(name = "\"user\"")
@Getter
@Setter
public class User {

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
    private Integer userId;

    @Column(length = 50)
    private String username;

    @Column(length = 100)
    private String password;

    @Column(length = 100)
    private String email;

    @Column(length = 100)
    private String fullName;

    @Column
    private LocalDate dateOfBirth;

    @Column
    private Boolean gender;

    @Column(length = 200)
    private String address;

    @Column(length = 20)
    private String phoneNumber;

    @Column
    private Boolean loginPermission;

    @Column(columnDefinition = "datetime2")
    private OffsetDateTime registrationDate;

    @Column
    private Boolean lockStatus;

    @OneToMany(mappedBy = "user")
    private Set<Order> userOrders;

    @OneToMany(mappedBy = "user")
    private Set<Product> userProducts;

    @OneToMany(mappedBy = "user")
    private Set<Review> userReviews;

    @OneToMany(mappedBy = "user")
    private Set<ImportReceipt> userImportReceipts;

    @OneToMany(mappedBy = "user")
    private Set<Cart> userCarts;

    @OneToMany(mappedBy = "user")
    private Set<ConfirmationCode> userConfirmationCodes;

    @OneToMany(mappedBy = "user")
    private Set<LoginActivity> userLoginActivitys;

    @OneToMany(mappedBy = "user")
    private Set<IncorrectPasswordActivity> userIncorrectPasswordActivitys;

}
