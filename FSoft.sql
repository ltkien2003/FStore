CREATE DATABASE FStore;
GO

USE FStore;
GO

-- Create table User
CREATE TABLE [User] (
  UserID INT PRIMARY KEY IDENTITY(1,1),
  Username NVARCHAR(50) UNIQUE,
  Password NVARCHAR(100),
  Email NVARCHAR(100) UNIQUE,
  FullName NVARCHAR(100),
  DateOfBirth DATE,
  Gender BIT,
  Address NVARCHAR(200),
  PhoneNumber NVARCHAR(20) UNIQUE,
  LoginPermission BIT,
  RegistrationDate DATETIME DEFAULT GETDATE(),
  LockStatus BIT DEFAULT 0
);

-- Create table PaymentMethod
CREATE TABLE PaymentMethod (
  PaymentMethodID INT PRIMARY KEY IDENTITY(1,1),
  PaymentMethodName NVARCHAR(100),
  Description NVARCHAR(MAX),
  Display BIT
);

-- Create table Discount
CREATE TABLE Discount (
  DiscountID INT PRIMARY KEY IDENTITY(1,1),
  DiscountName NVARCHAR(100) UNIQUE,
  Description NVARCHAR(MAX),
  StartDate DATETIME,
  EndDate DATETIME,
  DiscountRate DECIMAL(5, 2) CHECK (DiscountRate >= 0.01 AND DiscountRate <= 1.00),
  Display BIT
);

-- Create table Order
CREATE TABLE [Order] (
  OrderID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT,
  DirectDiscount FLOAT,
  PaymentMethodID INT,
  OrderDate DATETIME,
  ShippingAddress NVARCHAR(200),
  DeliveryDate DATETIME,
  Note NVARCHAR(MAX),
  PaymentStatus BIT,
  DeliveryStatus BIT,
  FOREIGN KEY (UserID) REFERENCES [User](UserID),
  FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);

-- Create table Supplier
CREATE TABLE Supplier (
  SupplierID INT PRIMARY KEY IDENTITY(1,1),
  SupplierName NVARCHAR(100),
  BusinessName NVARCHAR(100),
  PhoneNumber NVARCHAR(20) UNIQUE,
  Email NVARCHAR(100),
  Display BIT
);

-- Create table ProductGroup
CREATE TABLE ProductGroup (
  ProductGroupID INT PRIMARY KEY IDENTITY(1,1),
  ProductGroupName NVARCHAR(100)
);

-- Create table ProductCategory
CREATE TABLE ProductCategory (
  ProductCategoryID INT PRIMARY KEY IDENTITY(1,1),
  ProductGroupID INT,
  ProductCategoryName NVARCHAR(100),
  FOREIGN KEY (ProductGroupID) REFERENCES ProductGroup(ProductGroupID)
);

-- Create table SubCategory
CREATE TABLE SubCategory (
  SubCategoryID INT PRIMARY KEY IDENTITY(1,1),
  ProductCategoryID INT,
  SubCategoryName NVARCHAR(100),
  FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
);

-- Create table Product
CREATE TABLE Product (
  ProductID INT PRIMARY KEY IDENTITY(1,1),
  ProductCategoryID INT,
  SubCategoryID INT,
  UserID INT,
  ProductName NVARCHAR(100),
  Description NVARCHAR(MAX),
  Origin NVARCHAR(100),
  Price FLOAT,
  ViewCount INT,
  Available BIT,
  Featured BIT,
  Display BIT,
  CreatedDate DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID),
  FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID),
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table DirectDiscount
CREATE TABLE DirectDiscount (
  DirectDiscountID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  DirectDiscount DECIMAL(5, 2) CHECK (DirectDiscount >= 0.01 AND DirectDiscount <= 1.00),
  StartDate DATETIME,
  EndDate DATETIME,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table Color
CREATE TABLE Color (
  ColorID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  ColorName NVARCHAR(100),
  ImagePath NVARCHAR(MAX),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table ProductDetail
CREATE TABLE ProductDetail (
  ProductDetailID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  ColorID INT,
  QuantityInStock INT,
  StorageLocation NVARCHAR(200),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (ColorID) REFERENCES Color(ColorID)
);

-- Create table LaptopConfiguration
CREATE TABLE LaptopConfiguration (
  LaptopID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  CPU NVARCHAR(100),
  RAM NVARCHAR(100),
  HardDrive NVARCHAR(100),
  Screen NVARCHAR(100),
  GraphicsCard NVARCHAR(100),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table PhoneConfiguration
CREATE TABLE PhoneConfiguration (
  PhoneID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  CPU NVARCHAR(100),
  RAM NVARCHAR(100),
  InternalMemory NVARCHAR(100),
  Screen NVARCHAR(100),
  Camera NVARCHAR(100),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table OrderDetail
CREATE TABLE OrderDetail (
  OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
  OrderID INT,
  ProductID INT,
  ColorID INT,
  Quantity INT,
  Price FLOAT,
  Discount FLOAT,
  FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (ColorID) REFERENCES Color(ColorID)
);

-- Create table Review
CREATE TABLE Review (
  ReviewID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  Title NVARCHAR(200),
  UserID INT,
  ReviewDate DATETIME DEFAULT GETDATE(),
  Display BIT,
  Rating INT,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table ProductImage
CREATE TABLE ProductImage (
  ProductImageID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  ImagePath NVARCHAR(MAX),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table ImportReceipt
CREATE TABLE ImportReceipt (
  ImportReceiptID INT PRIMARY KEY IDENTITY(1,1),
  SupplierID INT,
  UserID INT,
  TotalAmount FLOAT,
  ImportDate DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table ImportReceiptDetail
CREATE TABLE ImportReceiptDetail (
  ImportReceiptDetailID INT PRIMARY KEY IDENTITY(1,1),
  ProductID INT,
  ImportReceiptID INT,
  Quantity INT,
  Price FLOAT,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (ImportReceiptID) REFERENCES ImportReceipt(ImportReceiptID)
);

-- Create table Cart
CREATE TABLE Cart (
  CartID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT,
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table CartDetail
CREATE TABLE CartDetail (
  CartID INT,
  ProductID INT,
  ColorID INT,
  Quantity INT,
  PRIMARY KEY (CartID, ProductID),
  FOREIGN KEY (CartID) REFERENCES Cart(CartID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
  FOREIGN KEY (ColorID) REFERENCES Color(ColorID)
);

-- Create table ProductDiscount
CREATE TABLE ProductDiscount (
  ProductDiscountID INT PRIMARY KEY IDENTITY(1,1),
  DiscountID INT,
  ProductID INT,
  FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create table CategoryDiscount
CREATE TABLE CategoryDiscount (
  CategoryDiscountID INT PRIMARY KEY IDENTITY(1,1),
  DiscountID INT,
  ProductCategoryID INT,
  FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID),
  FOREIGN KEY (ProductCategoryID) REFERENCES ProductCategory(ProductCategoryID)
);

-- Create table SubCategoryDiscount
CREATE TABLE SubCategoryDiscount (
  SubCategoryDiscountID INT PRIMARY KEY IDENTITY(1,1),
  DiscountID INT,
  SubCategoryID INT,
  FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID),
  FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID)
);

-- Create table ConfirmationCode
CREATE TABLE ConfirmationCode (
  UserID INT PRIMARY KEY,
  OTPCode NVARCHAR(100),
  IsConfirmed BIT,
  OTPCreationDate DATETIME,
  OTPExpirationDate DATETIME,
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table LoginActivity
CREATE TABLE LoginActivity (
  LoginActivityID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT,
  LoginTime DATETIME,
  IPAddress NVARCHAR(50),
  Success BIT,
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

-- Create table IncorrectPasswordActivity
CREATE TABLE IncorrectPasswordActivity (
  IncorrectPasswordActivityID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT,
  FailedPasswordAttempts INT DEFAULT 0,
  LastFailedPasswordTime DATETIME,
  AccountLockTime DATETIME,
  IPAddress NVARCHAR(50),
  FOREIGN KEY (UserID) REFERENCES [User](UserID)
);
GO
USE [FStore]
GO
SET IDENTITY_INSERT [dbo].[ProductGroup] ON 

INSERT [dbo].[ProductGroup] ([ProductGroupID], [ProductGroupName]) VALUES (1, N'Ðiện thoại')
INSERT [dbo].[ProductGroup] ([ProductGroupID], [ProductGroupName]) VALUES (2, N'Laptop')
SET IDENTITY_INSERT [dbo].[ProductGroup] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductCategory] ON 

INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (1, 1, N'Iphone')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (2, 1, N'Xiaomi')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (3, 1, N'Samsung')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (4, 2, N'Asus')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (5, 2, N'Dell')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (6, 2, N'HP')
INSERT [dbo].[ProductCategory] ([ProductCategoryID], [ProductGroupID], [ProductCategoryName]) VALUES (7, 2, N'Macbook')
SET IDENTITY_INSERT [dbo].[ProductCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[SubCategory] ON 

INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (1, 4, N'Vivobook')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (2, 4, N'Zenbook')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (3, 5, N'Latitude')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (4, 5, N'XPS')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (5, 6, N'Pavilion')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (6, 6, N'Envy')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (7, 7, N'Air')
INSERT [dbo].[SubCategory] ([SubCategoryID], [ProductCategoryID], [SubCategoryName]) VALUES (8, 7, N'Pro')
SET IDENTITY_INSERT [dbo].[SubCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (1, N'nguyenvanhoa', N'1', N'nguyenvanhoa@gmail.com', N'Nguyễn Văn Hòa', CAST(N'1987-05-12' AS Date), 0, N'N Số 10, Đường Trần Phú, Quận Ba Đình, Hà Nội', N'0987654321', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (2, N'tranthithanh', N'$argon2id$v=19$m=65536,t=10,p=1$oZ2GoGTMyL0WShPLA9hz3A$lQXvRdzJDYvBk66rQnwSBS2OZ1MgeLdd9n5U9S2PgAY', N'tranthithanh@gmail.com', N'Trần Thị Thanh', CAST(N'1992-02-20' AS Date), 1, N'N Số 15, Đường Nguyễn Văn Linh, Quận 1, TP. Hồ Chí Minh', N'0901234567', 0, CAST(N'2023-06-07T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (3, N'phamhongvan', N'Phamhongvan@1990', N'phamhongvan@gmail.com', N'Phạm Hồng Vân', CAST(N'1990-11-03' AS Date), 1, N'N Số 25, Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', N'0918765432', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (4, N'leducminh', N'Leducminh@1985', N'leducminh@gmail.com', N'Lê Đức Minh', CAST(N'1985-09-15' AS Date), 0, N'N Số 30, Đường Hùng Vương, Quận Ngô Quyền, Hải Phòng', N'0976543210', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (5, N'nguyenthikimanh', N'Nguyenthikimanh@1993', N'nguyenthikimanh@gmail.com', N'Nguyễn Thị Kim Anh', CAST(N'1993-07-28' AS Date), 1, N'N Số 5A, Đường Dĩ An, Thị xã Dĩ An, Bình Dương', N'0932189876', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (6, N'vuthidung', N'Vuthidung@1998', N'vuthidung@gmail.com', N'Vũ Thị Dung', CAST(N'1998-12-10' AS Date), 1, N'N Số 17, Đường Lê Lợi, Thành phố Hà Tĩnh, Hà Tĩnh', N'0965432109', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (7, N'hoangvanquan', N'Hoangvanquan@1991', N'hoangvanquan@gmail.com', N'Hoàng Văn Quân', CAST(N'1991-04-02' AS Date), 0, N'N Số 20, Đường Hùng Vương, TP. Vinh, Nghệ An', N'0943210987', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (8, N'nguyenngocthanh', N'Nguyenngocthanh@1996', N'nguyenngocthanh@gmail.com', N'Nguyễn Ngọc Thanh', CAST(N'1996-08-18' AS Date), 1, N'N Số 12, Đường Lê Lợi, Quận Thanh Hóa, Thanh Hóa', N'0923456789', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (9, N'tranduyhung', N'Tranduyhung@1989', N'tranduyhung@gmail.com', N'Trần Duy Hùng', CAST(N'1989-03-05' AS Date), 0, N'N Số 7, Đường Nguyễn Huệ, TP. Đồng Hới, Quảng Bình', N'0910324567', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (10, N'phamthihong', N'Phamthihong@1994', N'phamthihong@gmail.com', N'Phạm Thị Hồng', CAST(N'1994-11-09' AS Date), 1, N'N Số 3, Đường Hoàng Văn Thụ, Quận Hồng Bàng, Hải Phòng', N'09878454321', 0, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (11, N'trinhthithao', N'Trinhthithao@1995', N'trinhthithao@gmail.com', N'Trịnh Thị Thảo', CAST(N'1995-09-07' AS Date), 1, N'N Số 8, Đường Lê Duẩn, Quận Hai Bà Trưng, Hà Nội', N'0978123456', 1, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (12, N'nguyenmylinh', N'$argon2id$v=19$m=65536,t=10,p=1$YrWNCxMXSqwkeadlOkr0DQ$wovd2iP1ubDt0si0uIuWurrbmkM8pTbO7yNkILX9NCY', N'nguyenmylinh@gmail.com', N'Nguyễn Mỹ Linh', CAST(N'1997-03-15' AS Date), 1, N'N Số 2, Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh', N'0909876543', 1, CAST(N'2023-06-07T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (13, N'phanduongngoc', N'Phanduongngoc@1990', N'phanduongngoc@gmail.com', N'Phan Dương Ngọc', CAST(N'1990-06-20' AS Date), 1, N'N Số 18, Đường Trần Phú, Quận Hải Châu, Đà Nẵng', N'0912345678', 1, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (14, N'tranthithuha', N'Tranthithuha@1991', N'tranthithuha@gmail.com', N'Trần Thị Thu Hà', CAST(N'1991-08-12' AS Date), 1, N'N Số 6, Đường Điện Biên Phủ, Quận Hải Châu, Đà Nẵng', N'0932149876', 1, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (15, N'nguyenkhanhlinh', N'Nguyenkhanhlinh@1993', N'nguyenkhanhlinh@gmail.com', N'Nguyễn Khánh Linh', CAST(N'1993-11-25' AS Date), 1, N'N Số 4, Đường Nguyễn Đức Cảnh, Quận Lê Chân, Hải Phòng', N'0987254321', 1, CAST(N'2023-06-07T16:15:54.470' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (16, N'Chibao1234', N'$argon2id$v=19$m=65536,t=10,p=1$3V+uwf4avvVd2rCufzl2YA$D3aRP8ja8yMpW6737zjdCRf4Lub34nA/G9KtHktWCnk', N'hello@gmail.com', N'Hello', NULL, NULL, NULL, N'0901238567', 0, CAST(N'2023-06-17T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (17, N'kien', N'$argon2id$v=19$m=65536,t=10,p=1$MAKhGT4S8+xCVnOgWIEPMw$Iam6oSnl8gtjtdoLAiJEeuQnDQMYsTInFRkKJSqgMAs', N'kien21265@gmail.com', N'Kiên', NULL, NULL, N'N Số 39'', Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', N'0787850051', 0, CAST(N'2023-06-17T00:00:00.000' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Username], [Password], [Email], [FullName], [DateOfBirth], [Gender], [Address], [PhoneNumber], [LoginPermission], [RegistrationDate], [LockStatus]) VALUES (18, N'Chibao1236', N'$argon2id$v=19$m=65536,t=10,p=1$6bOCxLyHcpE6+MdZabzjuw$FZebB+HsfHvzdJRqbQtaucK5xh5qK7Snt+Gm9KfaePY', N'luntpc04659@fpt.edu.vn', N'Dương Chí Bảo', CAST(N'2007-06-21' AS Date), 1, N'', N'0355323355', 0, CAST(N'2023-06-17T00:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (1, 1, NULL, NULL, N'iPhone 14 Pro Max 128GB', N'Những tính năng nổi bật và cực kỳ hữu ích trên iOS 16 có thể kể đến như: Tùy chỉnh màn hình khóa, thêm widget mới cho màn hình khóa, Live Text, tách nền ảnh,... đều được mình sử dụng hằng ngày một cách tiện lợi cho công việc và kể cả những nhu cầu giải trí. Bên trong điện thoại sẽ được tích hợp viên pin có dung lượng lên tới 4323 mAh nên mình cũng đã an tâm hơn trong việc sử dụng máy phục vụ các tác vụ cơ bản cả ngày.', N'Hoa Kỳ', 30990000, 0, 1, 1, 1, CAST(N'2023-06-07T18:12:06.313' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (2, 3, NULL, NULL, N'Samsung Galaxy Z Fold4 5G 512GB', N'Galaxy Z Fold4 có lẽ là cái tên nhận được nhiều sự quan tâm, chú ý đến từ sự kiện Unpacked thường niên của Samsung nhờ sở hữu màn hình lớn cùng cơ chế gấp gọn giúp bạn có thể dễ dàng mang theo bên mình đi bất kỳ nơi đâu. Cùng với đó là sự nâng cấp về hiệu năng và phần mềm giúp thiết bị xử lý tốt hầu hết mọi tác vụ từ làm việc, học tập đến giải trí.', N'Hàn Quốc', 44490000, 0, 1, 1, 1, CAST(N'2023-06-13T14:17:04.410' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (3, 3, NULL, NULL, N'Samsung Galaxy S23 Ultra 12/1TB
', N'Samsung Galaxy S23 Ultra viết tiếp huyền thoại từ người tiền nhiệm. Không hào nhoáng về diện mạo nhưng S23 Ultra vẫn thể hiện được nét đẹp bền vững theo thời gian. Đặc biệt, đem đến cho người dùng sức mạnh đỉnh cao từ camera 200MP và vi xử lý Snapdragon 8 Gen 2 độc quyền.', N'Hàn Quốc', 34990000, 0, 1, 1, 1, CAST(N'2023-06-13T14:18:10.660' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (4, 2, NULL, NULL, N'Xiaomi 12 Pro', N'Xiaomi 12 Pro - Bậc thầy nhiếp ảnh, smartphone mạnh mẽ nhất thế giới, thiết kế tuyệt đẹp, sạc cực nhanh,… Tất cả đã sẵn sàng biến mọi khoảnh khắc trở thành tác phẩm nghệ thuật, màn hình đẹp nhất thế giới, bộ sạc nhanh lên tới 120W.', N'Trung Quốc', 44990000, 0, 1, 1, 1, CAST(N'2023-06-13T14:21:33.540' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (5, 2, NULL, NULL, N'Xiaomi 12T 8/128GB', N'Xiaomi 12T là sản phẩm vừa mới trình làng của nhà Xiaomi với sự đột phá về hiệu năng, hứa hẹn sẽ mang đến cho người dùng những trải nghiệm chơi game tuyệt vời hay xử lý các công việc có tính đồ họa cao. Bên cạnh đó, máy cũng sở hữu màn hình được cải tiến hơn cùng hệ thống camera xịn sò. Với những ưu điểm như trên, chắc chắn Xiaomi 12T sẽ đáp ứng tốt mọi nhu cầu sử dụng của bạn.', N'Trung Quốc', 12490000, 0, 1, 1, 1, CAST(N'2023-06-13T14:23:55.343' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (6, 2, NULL, NULL, N'Xiaomi 13 Pro 12/256GB', N'Sau thời gian mong chờ thì Xiaomi đã chính thức ra mắt siêu phẩm Xiaomi 13 Pro tại thị trường Việt Nam. Dự kiến, đây sẽ là một trong những mẫu smartphone cao cấp bậc nhất hiện nay nhờ sở hữu thiết kế thời thượng, hiệu năng siêu mạnh và cụm camera hợp tác với thương hiệu Leica nổi tiếng thế giới. Điều này sẽ giúp Xiaomi 13 Pro đánh bại đối thủ của mình trong cùng phân khúc giá.', N'Trung Quốc', 29990000, 0, 1, 1, 1, CAST(N'2023-06-13T14:24:59.013' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (7, 2, NULL, NULL, N'Xiaomi 13 8/256GB', N'Xiaomi 13 là smartphone tiếp theo được Xiaomi trình làng với khá nhiều điều mới mẻ cùng sức mạnh đáng kinh ngạc. Nổi bật có thể kể đến như thiết kế sang trọng, màn hình 120Hz, con chip Snapdragon 8 Gen 2 và cụm camera hợp tác với Leica. Thiết bị hứa hẹn sẽ thu hút nhiều tín đồ đam mê công nghệ trong năm nay.', N'Trung Quốc', 22990000, 0, 1, 1, 1, CAST(N'2023-06-13T14:26:28.900' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (8, 1, NULL, NULL, N'iPhone 13 Pro 1TB', N'Phiên bản iPhone 13 Pro 1TB ra mắt ngày 17/09/2021 tại Mỹ. iPhone 13 Pro gồm các phiên bản dung lượng bộ nhớ 128B, 256GB, 512GB và 1TB. Trong đó iPhone 13 Pro 1TB là phiên bản dung lượng cao nhất.', N'Hoa Kỳ', 30590000, 0, 1, 1, 1, CAST(N'2023-06-13T14:27:37.040' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (9, 1, NULL, NULL, N'iPhone 13 128GB', N'iPhone 13 – Siêu phẩm mới của "nhà Táo" sẽ đem đến trải nghiệm thú vị cho người dùng. Màu sắc mới, camera nhiều thay đổi, vi xử lý mạnh mẽ hơn, pin lâu hơn,… là những gì iPhone 13 sở hữu và chinh phục được những vị khách khó tính nhất. Cùng cập nhật thông tin, đặc điểm nổi bật về smartphone Apple này.', N'Hoa Kỳ', 19990000, 0, 1, 0, 1, CAST(N'2023-06-13T14:30:19.950' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (10, 1, NULL, NULL, N'iPhone 14 Plus 512GB', N'Sau khi tất cả các phiên bản iPhone 14 được ra mắt thì dường như iPhone 14 Plus 512GB nhận được nhiều sự ưu ái của cộng đồng iFans hơn bởi màn hình lớn, camera đỉnh cao, kho lưu trữ khổng lồ, đặc biệt giá thành rẻ hơn so với những sản phẩm 512GB khác. Chính vì vậy, nếu bạn đang có ý định tìm hiểu về sản phẩm này thì hãy theo dõi ngay bài viết dưới đây nhé!', N'Hoa Kỳ', 34990000, 0, 1, 1, 1, CAST(N'2023-06-13T14:35:20.197' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (12, 7, NULL, NULL, N'Laptop APPLE MacBook Pro 14"', N'LapTaop', N'Hoa Kỳ', 52290000, 0, 1, 1, 0, CAST(N'2023-06-13T00:00:00.000' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (13, 7, NULL, NULL, N'MacBook Pro 2022 13 inch Z16S00034', N'MacBook Pro 13 inch Z16S00034 của nhà Apple sở hữu một thiết kế thời thượng, sang trọng cùng với tính di động và gọn nhẹ. Máy được trang bị bộ vi xử lý độc quyền Apple M2 có hiệu năng hoạt động tối ưu, giúp xử lý tốt mọi tác vụ hàng ngày hay chỉnh sửa đồ họa. Không những thế, chiếc máy này còn đảm bảo đáp ứng đủ dải nhu cầu sử dụng từ cơ bản đến nâng cao hứa hẹn sẽ làm hài lòng đến mọi khách hàng.', N'Hoa Kỳ', 44462000, 0, 1, 1, 0, CAST(N'2023-06-13T21:52:17.653' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (14, 7, NULL, NULL, N'MacBook Pro 2022 13.3 inch MNEJ3SA/A', N'MacBook Pro M2 - MNEJ3SA/A là là một sản phẩm cao cấp đến từ thương hiệu nổi tiếng hàng đầu Apple. Chiếc laptop này sở hữu thiết kế hiện đại, màn hình hiển thị sắc nét, hiệu năng vượt trội, đây hứa hẹn sẽ là một sản phẩm mang đến cho bạn những trải nghiệm tuyệt vời, phù hợp với nhiều đối tượng khách hành khác nhau.', N'Hoa Kỳ', 39300000, 0, 1, 1, 0, CAST(N'2023-06-13T21:53:02.947' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (16, 4, NULL, NULL, N'Laptop ASUS ROG Flow X16 GV601VV', N'Đang cập nhật
', N'Trung Quốc', 65990000, 0, 1, 1, 0, CAST(N'2023-06-13T21:58:00.860' AS DateTime))
INSERT [dbo].[Product] ([ProductID], [ProductCategoryID], [SubCategoryID], [UserID], [ProductName], [Description], [Origin], [Price], [ViewCount], [Available], [Featured], [Display], [CreatedDate]) VALUES (17, 4, NULL, NULL, N'Laptop ASUS Gaming ROG G614JI-N4084W', N'Đang cập nhật', N'Trung Quốc', 60990000, 0, 1, 1, 0, CAST(N'2023-06-13T21:58:58.293' AS DateTime))
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentMethod] ON 

INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentMethodName], [Description], [Display]) VALUES (1, N'Tại cửa hàng', N'Hình thức thanh toán trực tiếp tại cửa hàng', 1)
INSERT [dbo].[PaymentMethod] ([PaymentMethodID], [PaymentMethodName], [Description], [Display]) VALUES (2, N'Ví VNPAY', N'Hình thức thanh toán qua Ví VNPAY', 0)
SET IDENTITY_INSERT [dbo].[PaymentMethod] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (66, 17, 0, 1, CAST(N'2023-06-17T13:46:37.500' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (67, 17, 0, 1, CAST(N'2023-06-17T13:50:39.140' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (68, 17, 0, 1, CAST(N'2023-06-17T13:54:42.187' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (69, 17, 0, 1, CAST(N'2023-06-17T14:03:40.337' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (70, 17, 0, 1, CAST(N'2023-06-17T14:05:13.650' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (71, 17, 0, 1, CAST(N'2023-06-17T14:06:18.917' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (72, 17, 0, 1, CAST(N'2023-06-17T14:07:37.307' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (73, 17, NULL, 2, CAST(N'2023-06-17T14:11:58.973' AS DateTime), NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (74, 17, NULL, 2, CAST(N'2023-06-17T14:16:04.907' AS DateTime), NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (75, 17, NULL, 2, CAST(N'2023-06-17T14:19:31.920' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (76, 17, NULL, 2, CAST(N'2023-06-17T14:21:03.933' AS DateTime), NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (77, 17, NULL, 2, CAST(N'2023-06-17T14:26:09.830' AS DateTime), NULL, NULL, NULL, 1, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (78, 17, 0, 1, CAST(N'2023-06-17T15:39:07.783' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (79, 17, 0, 1, CAST(N'2023-06-17T15:44:29.163' AS DateTime), NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (80, 17, 0, 1, CAST(N'2023-06-17T16:24:36.943' AS DateTime), N'N Số 39'', Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (81, 17, 0, 1, CAST(N'2023-06-17T16:59:36.553' AS DateTime), N'N Số 39'', Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', NULL, NULL, 0, 0)
INSERT [dbo].[Order] ([OrderID], [UserID], [DirectDiscount], [PaymentMethodID], [OrderDate], [ShippingAddress], [DeliveryDate], [Note], [PaymentStatus], [DeliveryStatus]) VALUES (82, 17, NULL, 2, CAST(N'2023-06-17T17:00:50.103' AS DateTime), N'N Số 39'', Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', NULL, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[Color] ON 

INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (1, 1, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14ProMax_128GB_Black.jpeg?alt=media&token=9cb548eb-1d2a-4773-8942-c8930e29f74d')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (2, 1, N'Vàng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14ProMax_128GB_Gold.jpeg?alt=media&token=47dfa7c2-fb5d-4427-a566-90d0aeb78403')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (3, 1, N'Tím', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14ProMax_128GB_Purple.jpeg?alt=media&token=1ff9db46-6a8d-45f2-9a61-38fd5cc270e1')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (4, 1, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14ProMax_128GB_White.jpeg?alt=media&token=cca4b515-38a1-4d4e-b9ef-1822addea67e')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (5, 3, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungS23Ultra_1TB_Black.jpeg?alt=media&token=08a6ecdb-1ef1-4231-9cfb-1f70a9f7e33f&_gl=1*5ayjc1*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjAuMTY4NjY0Mjc4NC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (6, 3, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungS23Ultra_1TB_Green.jpeg?alt=media&token=81d56857-b4bb-42ac-9fe5-e62f0e3d29a9&_gl=1*1m2r9ni*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mjc5OS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (7, 3, N'Hồng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungS23Ultra_1TB_Pink.jpeg?alt=media&token=a06d2f50-6b6d-4604-9cb3-eb89fd53f591&_gl=1*13kaqdm*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MjgwNS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (8, 3, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungS23Ultra_1TB_White.jpeg?alt=media&token=943c8483-1281-459f-8d59-a1041a380bc7&_gl=1*5r44t3*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MjgxMi4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (9, 2, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungZFold4_512GB_Black.jpeg?alt=media&token=f9f9dcdc-9014-4dcc-a3e4-122f38a71bad&_gl=1*x4fuyn*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MjkxMS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (10, 2, N'Vàng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungZFold4_512GB_Gold.jpeg?alt=media&token=16821826-e027-4eff-a766-56d28c6fa6f3&_gl=1*rywpng*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MjkxNy4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (11, 2, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FSamsungZFold4_512GB_Green.jpeg?alt=media&token=dc3862b6-ab6b-48a1-888a-b7ce16329c25&_gl=1*1pflpu2*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MjkyNS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (12, 4, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12Pro_256GB_Black.jpeg?alt=media&token=fb46d518-3fe9-4d72-89b4-698566d2a7f0&_gl=1*1wirrhl*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mjk3NS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (13, 4, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12Pro_256GB_Blue.jpeg?alt=media&token=d1d84995-960d-4ff7-991b-103975e656b6&_gl=1*167y6tu*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mjk4My4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (14, 4, N'Hồng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12Pro_256GB_Pink.jpeg?alt=media&token=e9f700e3-b897-4ca8-8c66-ae6b83a3faa0&_gl=1*13t4hsf*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mjk5MC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (15, 5, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12T_128GB_Black.jpeg?alt=media&token=cb6a94a6-af45-4435-8321-2b4a8b35f402&_gl=1*1jw1cwp*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzA0Mi4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (16, 5, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12T_128GB_Blue.jpeg?alt=media&token=41870f7c-2616-4ab3-a4ea-3a88bbdab147&_gl=1*1ugyg7y*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzA0OS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (17, 5, N'Bạc', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi12T_128GB_Silver.jpeg?alt=media&token=907ccad4-dff2-4dcc-8014-f460c3d445b0&_gl=1*1l1bw2v*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzA1Ny4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (18, 6, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi13Pro_256GB_White.jpeg?alt=media&token=1a798ad9-21ac-4d93-ab3f-8b6cc35780a1&_gl=1*af5384*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzY0NC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (19, 6, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi13Pro_256GB_Black.jpeg?alt=media&token=2535a758-2c8a-4a5d-be88-df36f35ea04e&_gl=1*1lnlfhi*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzU4Ni4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (20, 7, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi13_256GB_Black.jpeg?alt=media&token=e0574dce-66ab-42db-8af3-88e0700eb64d&_gl=1*13pbdxj*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzY2Ny4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (21, 7, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FXiaomi13_256GB_Green.jpeg?alt=media&token=d99eefc5-78d6-4a54-8fc7-9fbb2446186f&_gl=1*18jbvsj*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzY4OS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (22, 8, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13Pro_1TB_Black.jpeg?alt=media&token=318e2a5c-63ec-4958-980e-84556c84191b&_gl=1*1o918u1*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzcwOS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (23, 8, N'Xanh Dương', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13Pro_1TB_Blue.jpeg?alt=media&token=186ce1a8-a8a2-43b6-ad76-ae599818b7ff&_gl=1*1lpcvyu*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzcyMS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (24, 8, N'Vàng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13Pro_1TB_Gold.jpeg?alt=media&token=55f8bfcc-1157-46bc-afd9-12c07eaddb1b&_gl=1*1ljsink*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzczNi4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (25, 8, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13Pro_1TB_White.jpeg?alt=media&token=a25b219a-cd24-42c3-abbb-7814214e1a6c&_gl=1*15dqkmp*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzc1NC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (26, 8, N'Xanh Lá', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13Pro_1TB_Green.jpeg?alt=media&token=674d6265-7eb2-4c47-9b6d-cf4064fa612f&_gl=1*15jf3h3*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzc2My4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (27, 9, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13_128GB_Black.jpeg?alt=media&token=df00d5f0-1761-4dcf-aa52-2a863c36aed3&_gl=1*atg6y1*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzc4NS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (28, 9, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13_128GB_Blue.jpeg?alt=media&token=84dcd2bf-1358-448c-a91e-00755d336678&_gl=1*ds9s1g*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzc5Ni4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (29, 9, N'Hồng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13_128GB_Pink.jpeg?alt=media&token=d23d6b17-ffe9-42d0-abf5-ce2c50531cbe&_gl=1*1xiu6ye*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzgxMS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (30, 9, N'Đỏ', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13_128GB_Red.jpeg?alt=media&token=20dbaf15-1160-4163-b670-168e19ed7e0a&_gl=1*1tyxep7*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzgyMi4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (31, 9, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone13_128GB_White.jpeg?alt=media&token=eea82d79-2cca-4cdd-81ed-3d9ff4deedcc&_gl=1*1nxll7t*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzgzOC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (32, 10, N'Tím', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14Plus_512GB_Purple.jpeg?alt=media&token=90939f38-4f7e-4b2e-bf1e-38193046de0f&_gl=1*1esufb9*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzg1NS4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (33, 10, N'Đỏ', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14Plus_512GB_Red.jpeg?alt=media&token=9a9f1e15-5232-4107-bce9-0e35cfa4001e&_gl=1*6hwc8n*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzg4MC4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (34, 10, N'Trắng', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14Plus_512GB_White.jpeg?alt=media&token=bb095aef-4a27-48ab-9b38-28edeefeb741&_gl=1*x77316*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzg5Ny4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (35, 10, N'Xanh', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14Plus_512GB_Blue.jpeg?alt=media&token=6159cd05-a3b6-40a2-836f-dc4481b66963&_gl=1*399j0s*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0MzkxNy4wLjAuMA..')
INSERT [dbo].[Color] ([ColorID], [ProductID], [ColorName], [ImagePath]) VALUES (36, 10, N'Đen', N'https://firebasestorage.googleapis.com/v0/b/fir-e2be5.appspot.com/o/user%2Fimages%2Fproduct%2FiPhone14Plus_512GB_Black.jpeg?alt=media&token=9bf79be3-9a24-47c6-8bcc-68ae1b1bf275&_gl=1*177177e*_ga*MTQ1MDE4MzUyMy4xNjg2NjQwMTk3*_ga_CW55HF8NVT*MTY4NjY0Mjc4NC4yLjEuMTY4NjY0Mzk0My4wLjAuMA..')
SET IDENTITY_INSERT [dbo].[Color] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 

INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (41, 66, 4, 5, 44990000, 0, 13)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (42, 67, 4, 3, 44990000, 0, 13)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (43, 68, 4, 2, 44990000, 0, 13)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (44, 69, 4, 3, 44990000, 0, 14)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (45, 70, 4, 4, 44990000, 0, 14)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (46, 71, 4, 3, 44990000, 0, 14)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (47, 72, 5, 2, 8743000, 0, 16)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (48, 73, 5, 2, 8743000, 0, 16)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (49, 74, 5, 3, 8743000, 0, 17)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (50, 75, 3, 7, 34990000, 0, 6)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (51, 76, 5, 5, 8743000, 0, 17)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (52, 77, 5, 2, 8743000, 0, 17)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (53, 78, 3, 3, 34990000, 0, 6)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (54, 79, 6, 2, 29990000, 0, 18)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (55, 80, 7, 5, 22990000, 0, 20)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (56, 81, 9, 1, 19990000, 0, 31)
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [Discount], [ColorID]) VALUES (57, 82, 6, 2, 29990000, 0, 18)
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Cart] ON 

INSERT [dbo].[Cart] ([CartID], [UserID]) VALUES (2, 2)
INSERT [dbo].[Cart] ([CartID], [UserID]) VALUES (4, 12)
INSERT [dbo].[Cart] ([CartID], [UserID]) VALUES (5, 16)
INSERT [dbo].[Cart] ([CartID], [UserID]) VALUES (6, 17)
INSERT [dbo].[Cart] ([CartID], [UserID]) VALUES (7, 18)
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductDetail] ON 

INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (1, 1, 1, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (2, 1, 2, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (3, 1, 3, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (4, 1, 4, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (5, 3, 5, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (6, 3, 6, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (7, 3, 7, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (8, 3, 8, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (9, 2, 9, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (10, 2, 10, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (11, 2, 11, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (12, 4, 12, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (13, 4, 13, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (14, 4, 14, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (15, 5, 15, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (16, 5, 16, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (17, 5, 17, 0, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (18, 6, 18, 6, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (19, 6, 19, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (20, 7, 20, 5, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (21, 7, 21, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (22, 8, 22, 3, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (23, 8, 23, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (24, 8, 24, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (25, 8, 25, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (26, 8, 26, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (27, 9, 27, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (28, 9, 28, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (29, 9, 29, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (30, 9, 30, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (31, 9, 31, 9, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (32, 10, 32, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (33, 10, 33, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (34, 10, 34, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (35, 10, 35, 10, N'Tại cửa hàng')
INSERT [dbo].[ProductDetail] ([ProductDetailID], [ProductID], [ColorID], [QuantityInStock], [StorageLocation]) VALUES (36, 10, 36, 10, N'Tại cửa hàng')
SET IDENTITY_INSERT [dbo].[ProductDetail] OFF
GO
INSERT [dbo].[ConfirmationCode] ([UserID], [OTPCode], [IsConfirmed], [OTPCreationDate], [OTPExpirationDate]) VALUES (2, N'514674', 0, CAST(N'2023-06-17T07:22:11.287' AS DateTime), CAST(N'2023-06-17T07:27:11.287' AS DateTime))
INSERT [dbo].[ConfirmationCode] ([UserID], [OTPCode], [IsConfirmed], [OTPCreationDate], [OTPExpirationDate]) VALUES (12, N'733226', 0, CAST(N'2023-06-17T07:56:57.147' AS DateTime), CAST(N'2023-06-17T08:01:57.147' AS DateTime))
INSERT [dbo].[ConfirmationCode] ([UserID], [OTPCode], [IsConfirmed], [OTPCreationDate], [OTPExpirationDate]) VALUES (16, N'584947', 0, CAST(N'2023-06-17T08:38:36.183' AS DateTime), CAST(N'2023-06-17T08:43:36.183' AS DateTime))
INSERT [dbo].[ConfirmationCode] ([UserID], [OTPCode], [IsConfirmed], [OTPCreationDate], [OTPExpirationDate]) VALUES (17, N'136886', 0, CAST(N'2023-06-17T12:59:41.927' AS DateTime), CAST(N'2023-06-17T13:04:41.927' AS DateTime))
INSERT [dbo].[ConfirmationCode] ([UserID], [OTPCode], [IsConfirmed], [OTPCreationDate], [OTPExpirationDate]) VALUES (18, N'875624', 0, CAST(N'2023-06-17T16:46:13.677' AS DateTime), CAST(N'2023-06-17T16:51:13.677' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Supplier] ON 

INSERT [dbo].[Supplier] ([SupplierID], [SupplierName], [BusinessName], [PhoneNumber], [Email], [Display]) VALUES (1, N'Samsung', N'Mua 100 Samsung', N'0989888484', N'samsung@gmail.com', 1)
SET IDENTITY_INSERT [dbo].[Supplier] OFF
GO
SET IDENTITY_INSERT [dbo].[DirectDiscount] ON 

INSERT [dbo].[DirectDiscount] ([DirectDiscountID], [ProductID], [DirectDiscount], [StartDate], [EndDate]) VALUES (1, 3, CAST(0.10 AS Decimal(5, 2)), CAST(N'2023-06-16T00:00:00.000' AS DateTime), CAST(N'2023-07-24T14:42:00.000' AS DateTime))
INSERT [dbo].[DirectDiscount] ([DirectDiscountID], [ProductID], [DirectDiscount], [StartDate], [EndDate]) VALUES (2, 5, CAST(0.30 AS Decimal(5, 2)), CAST(N'2023-06-16T00:00:00.000' AS DateTime), CAST(N'2023-06-17T14:42:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[DirectDiscount] OFF
GO
SET IDENTITY_INSERT [dbo].[PhoneConfiguration] ON 

INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (4, 1, N'Apple A16 Bionic', N'6 GB', N'128 GB', N'OLED; 6.7 inch; 120Hz; 2778 x 1284 pixels; Kính cường lực Ceramic Shield', N'Chính 48 MP & Phụ 12 MP')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (5, 8, N'Apple A15 Bionic 6 nhân; Tốc độ CPU: 3.22 GHz; Apple GPU 5 nhân', N'6 GB', N'1 TB', N'OLED; 1170 x 2532 Pixels; 6.1"; Tần số quét 120 Hz;', N'12 MP; Xóa phông, Quay video 4K, Quay video HD')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (6, 9, N'Apple A15 Bionic 6 nhân; Tốc độ CPU: 3.22 GHz; Apple GPU 4 nhân', N'4 GB', N'128 GB', N'OLED; 1170 x 2532 Pixels; 6.1"; Tần số quét 60 Hz; Độ sáng tối đa 1200 nits', N'2 camera 12 MP; Quay phim 4K 2160p@24fps, 4K 2160p@30fps, 4K 2160p@60fps')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (7, 10, N'Apple A15 Bionic', N'6 GB', N'512GB', N'OLED Super Retina XDR; 6.7inch; Độ phân giải 2778 x 1284 pixel ở 458 ppi;', N'Chính 12MP: 26 mm, khẩu độ ƒ / 1.5, ổn định hình ảnh quang học thay đổi cảm biến')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (8, 3, N'Snapdragon® 8 Gen 2 Mobile Platform for Galaxy (4nm); 3.36 GHz, 2.8 GHz, 2 GHz', N'12 GB', N'1 TB', N'Dynamic AMOLED 2X;6.8"; 3088 x 1440; 1 - 120 Hz;', N'12 MP (UW) + 200 MP (W) + 10 MP (Tele 3x) + 10 MP (Tele 10x); Đèn flash kép')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (9, 2, N'Snapdragon 8+ Gen 1 8 nhân; 1 nhân 3.18 GHz, 3 nhân 2.7 GHz & 4 nhân 2 GHz; Adreno 670', N'12 GB', N'	512 GB', N'Dynamic AMOLED 2X; Chính: QXGA+ (2176 x 1812 Pixels) & Phụ: HD+', N'Chính 50 MP & Phụ 12 MP, 10 MP; 4K 2160p@30fps 4K 2160p@60fps 8K')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (10, 4, N'Snapdragon® 8 Gen 1 trên tiến trình 4nm', N'12GB', N'256GB', N'120Hz 6.73” AMOLED DotDisplay, WQHD+, 3200 x 1440, Tỉ lệ hiển thị: 20:9', N'Camera chính góc rộng 50MP, camera góc siêu rộng 50MP, camera tele 50MP')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (11, 6, N'AMOLED; 6,73" WQHD+ (2K+) (1440 x 3200 Pixels), 522 ppi; 120Hz; 20:9; 1900 nits', N'	12GB', N'256GB', N'AMOLED; 6,73" WQHD+ (2K+) (1440 x 3200 Pixels), 522 ppi; 120Hz; 20:9; 1900 nits', N'Chính 50 MP IMX989, kích thước cảm biến 1"; Kích thước điểm anh -1,6μm, kích thước Super Pixel')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (12, 5, N'Dimensity 8100-Ultra 2,85GHz', N'	8GB', N'128GB', N'	Màn hình AMOLED DotDisplay 6,67"; 20:9, 2712x1220; 120Hz; HDR10+', N'	108MP+8MP+2MP')
INSERT [dbo].[PhoneConfiguration] ([PhoneID], [ProductID], [CPU], [RAM], [InternalMemory], [Screen], [Camera]) VALUES (13, 7, N'Snapdragon 8 Gen 2, tiến trình 4nm', N'8 GB', N'256 GB', N'AMOLED; 6.36'''' Full HD+ (2400 x 1080 Pixels), 413 ppi; 120Hz; 20:9; 1900 nits', N'Chính 50 MP ƒ/1.8 Camera góc rộng & Phụ 12 MP ƒ/2.2 Camera góc siêu rộng, 10 MP ƒ/2.0 Camera tele')
SET IDENTITY_INSERT [dbo].[PhoneConfiguration] OFF
GO
SET IDENTITY_INSERT [dbo].[LaptopConfiguration] ON 

INSERT [dbo].[LaptopConfiguration] ([LaptopID], [ProductID], [CPU], [RAM], [Screen], [GraphicsCard], [HardDrive]) VALUES (1, 16, N'
Intel Core i9-13900H', N'16GB DDR5 4800MHz', N'
16" ( 2560 x 1600 ) WQXGA 240Hz , cảm ứng , Màn hình gương , FHD webcam', N'
RTX 4060 8GB GDDR6 / Intel Iris Xe Graphics', N'1TB SSD M.2 NVMe')
INSERT [dbo].[LaptopConfiguration] ([LaptopID], [ProductID], [CPU], [RAM], [Screen], [GraphicsCard], [HardDrive]) VALUES (2, 17, N'
Intel Core i7-13650HX ( 2.6 GHz - 4.9GHz / 24MB / 14 nhân, 20 luồng )', N'
16GB DDR5 4800MHz ( 2 Khe cắm / Hỗ trợ tối đa 32GB )', N'
16" ( 2560 x 1600 ) WQXGA IPS 240Hz , không cảm ứng , Màn hình chống lóa , HD webcam', N'
RTX 4070 8GB GDDR6 / Intel UHD Graphics 710', N'1TB SSD M.2 NVMe')
INSERT [dbo].[LaptopConfiguration] ([LaptopID], [ProductID], [CPU], [RAM], [Screen], [GraphicsCard], [HardDrive]) VALUES (3, 12, N'
Apple M2', N'
16GB', N'
14.2" ( 3024 x 1964 ) 120Hz , không cảm ứng , HD webcam', N'
Onboard', N'
512GB SSD')
INSERT [dbo].[LaptopConfiguration] ([LaptopID], [ProductID], [CPU], [RAM], [Screen], [GraphicsCard], [HardDrive]) VALUES (4, 13, N'
Apple M2', N'16GB', N'
13.3" ( 2560 x 1600 ) Retina IPS HD webcam', N'13.3" ( 2560 x 1600 ) Retina IPS HD webcam', N'
512GB SSD')
INSERT [dbo].[LaptopConfiguration] ([LaptopID], [ProductID], [CPU], [RAM], [Screen], [GraphicsCard], [HardDrive]) VALUES (5, 14, N'
Apple M2 chip', N'
8GB', N'
13.3" ( 2560 x 1600 ) IPS HD webcam', N'Onboard', N'
512GB SSD')
SET IDENTITY_INSERT [dbo].[LaptopConfiguration] OFF
GO


