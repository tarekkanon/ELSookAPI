USE [master]
GO
/****** Object:  Database [ELSookBase]    Script Date: 10/20/2023 11:52:39 PM ******/
CREATE DATABASE [ELSookBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ELSookBase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ELSookBase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ELSookBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ELSookBase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ELSookBase] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ELSookBase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ELSookBase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ELSookBase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ELSookBase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ELSookBase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ELSookBase] SET ARITHABORT OFF 
GO
ALTER DATABASE [ELSookBase] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ELSookBase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ELSookBase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ELSookBase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ELSookBase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ELSookBase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ELSookBase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ELSookBase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ELSookBase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ELSookBase] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ELSookBase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ELSookBase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ELSookBase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ELSookBase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ELSookBase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ELSookBase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ELSookBase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ELSookBase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ELSookBase] SET  MULTI_USER 
GO
ALTER DATABASE [ELSookBase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ELSookBase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ELSookBase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ELSookBase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ELSookBase] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ELSookBase] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ELSookBase] SET QUERY_STORE = ON
GO
ALTER DATABASE [ELSookBase] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ELSookBase]
GO
/****** Object:  User [elsookuser]    Script Date: 10/20/2023 11:52:39 PM ******/
CREATE USER [elsookuser] FOR LOGIN [elsookuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [elsookuser]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [elsookuser]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [elsookuser]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [elsookuser]
GO
USE [ELSookBase]
GO
/****** Object:  Sequence [dbo].[ShipmentTrackerNumberSeq]    Script Date: 10/20/2023 11:52:40 PM ******/
CREATE SEQUENCE [dbo].[ShipmentTrackerNumberSeq] 
 AS [int]
 START WITH 10000000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 99999999
 CACHE 
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[TagId] [int] IDENTITY(1,1) NOT NULL,
	[TagText] [varchar](255) NOT NULL,
	[TagStatus] [varchar](255) NOT NULL,
	[TagPriority] [int] NULL,
	[TagAvailability] [int] NULL,
	[ParentTagId] [int] NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TagsTreeView]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TagsTreeView] AS 
with cte as (
      select t.TagId AS QueryTag, t.TagId , t.TagText, t.TagStatus, t.TagPriority, t.TagAvailability, t.ParentTagId ,  0 AS Level
      from Tags t
      union all
      select cte.QueryTag AS CurrentTree, t.TagId , t.TagText, t.TagStatus, t.TagPriority, t.TagAvailability, t.ParentTagId ,  Level + 1
      from cte join
           Tags t
           on cte.ParentTagId = t.TagId
)
select cte.*
from (select cte.*, max(Level) over (partition by QueryTag) as maxlev
      from cte
     ) cte
--where QueryTag = 4;
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](255) NOT NULL,
	[CategoryDescription] [varchar](1000) NOT NULL,
	[CategoryStatus] [bit] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubCategories]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubCategories](
	[SubCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[SubCategoryName] [varchar](255) NOT NULL,
	[SubCategoryDescription] [varchar](1000) NOT NULL,
	[SubCategoryStatus] [bit] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](255) NOT NULL,
	[ProductDescription] [varchar](1000) NOT NULL,
	[ProductUnit] [varchar](100) NOT NULL,
	[SellerId] [int] NOT NULL,
	[SubCategoryId] [int] NOT NULL,
	[ProductStatus] [bit] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SellerProducts]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[SellerProducts] AS
SELECT 
	p.ProductId,
	p.SellerId,
	p.ProductName,
	p.ProductDescription,
	p.ProductUnit,
	CASE WHEN p.ProductStatus = 1 THEN 'Active' ELSE 'Suspended' END ProductStatus,
	sc.SubCategoryName, 
	sc.SubCategoryDescription,
	c.CategoryName,
	c.CategoryDescription
FROM Products p
INNER JOIN SubCategories sc ON p.SubCategoryId = sc.SubCategoryId
INNER JOIN Categories c on c.CategoryId = sc.CategoryId
;
GO
/****** Object:  View [dbo].[GetCategoriesDetails]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[GetCategoriesDetails] AS
SELECT cat.CategoryId,
		cat.CategoryName,
		cat.CategoryDescription,
		scat.SubCategoryId,
		scat.SubCategoryName,
		scat.SubCategoryDescription
FROM Categories cat
INNER JOIN SubCategories scat ON cat.CategoryId = scat.CategoryId AND scat.SubCategoryStatus = 1
WHERE cat.CategoryStatus = 1
GO
/****** Object:  Table [dbo].[ProductOptions]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductOptions](
	[ProductOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductOptionName] [varchar](255) NOT NULL,
	[ProductOptionStatus] [int] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariants]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariants](
	[ProductVariantId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductOptionId] [int] NOT NULL,
	[ProductVariantName] [varchar](255) NOT NULL,
	[ProductVariantPrice] [int] NOT NULL,
	[ProductVariantUnit] [varchar](100) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductVariantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](255) NOT NULL,
	[CustomerAddress] [varchar](255) NOT NULL,
	[CustomerEmail] [varchar](100) NOT NULL,
	[CustomerPassword] [varchar](100) NOT NULL,
	[CustomerPaymentChannels] [varchar](255) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[OrderTotal] [int] NOT NULL,
	[OrderStatus] [varchar](255) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderLines]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderLines](
	[OrderLineId] [int] IDENTITY(1,1) NOT NULL,
	[SellerId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductVariantId] [int] NOT NULL,
	[ProductOptionId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SellersOrders]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[SellersOrders] AS
select 
	o.CustomerId,
	c.CustomerName,
	o.OrderId,
	o.OrderDate,
	o.OrderStatus,
	o.OrderTotal,
	ol.OrderLineId,
	ol.ProductId,
	ol.ProductOptionId,
	ol.ProductVariantId,
	ol.Quantity,
	ol.Price,
	ol.SellerId,
	p.ProductName,
	p.ProductUnit,
	po.ProductOptionName,
	pv.ProductVariantName,
	pv.ProductVariantUnit
from OrderLines ol
inner join Orders o on o.OrderId = ol.OrderId
inner join Products p on p.ProductId = ol.ProductId
inner join ProductOptions po on po.ProductId = p.ProductId
inner join ProductVariants pv on pv.ProductId = p.ProductId and pv.ProductOptionId = po.ProductOptionId
inner join Customers c on c.CustomerId = o.CustomerId
GO
/****** Object:  Table [dbo].[Sellers]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sellers](
	[SellerId] [int] IDENTITY(1,1) NOT NULL,
	[SellerName] [varchar](255) NOT NULL,
	[SellerAddress] [varchar](255) NOT NULL,
	[SellerUsername] [varchar](100) NOT NULL,
	[SellerPassword] [varchar](100) NOT NULL,
	[SellerPaymentChannels] [varchar](255) NOT NULL,
	[SellerEmail] [varchar](100) NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[SellerStoreName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[SellerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductImages]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductImages](
	[ProductImageId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductImagePath] [varchar](1000) NOT NULL,
	[ProductImageType] [varchar](255) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CustomersOrders]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomersOrders] AS
select 
	o.CustomerId,
	o.OrderId,
	o.OrderDate,
	o.OrderStatus,
	o.OrderTotal,
	ol.OrderLineId,
	ol.ProductId,
	ol.ProductOptionId,
	ol.ProductVariantId,
	ol.Quantity,
	ol.Price,
	ol.SellerId,
	po.ProductOptionName,
	pv.ProductVariantName,
	pv.ProductVariantUnit,
	pi.ProductImagePath,
	pi.ProductImageType,
	s.SellerName
from Orders o
inner join OrderLines ol on o.OrderId = ol.OrderId
inner join Products p on p.ProductId = ol.ProductId
inner join ProductOptions po on po.ProductId = p.ProductId
inner join ProductVariants pv on pv.ProductId = p.ProductId and pv.ProductOptionId = po.ProductOptionId
inner join ProductImages pi on pi.ProductId = p.ProductId
inner join Sellers s on s.SellerId = ol.SellerId
GO
/****** Object:  View [dbo].[CartProductDetails]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CartProductDetails] AS
select 
p.ProductId,
po.ProductOptionId,
pv.ProductVariantId,
pv.ProductVariantPrice,
p.SellerId
from Products p
inner join ProductOptions po on p.ProductId = po.ProductId
inner join ProductVariants pv on p.ProductId = pv.ProductId and po.ProductOptionId = pv.ProductOptionId
GO
/****** Object:  Table [dbo].[Shipments]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipments](
	[ShipmentId] [int] IDENTITY(1,1) NOT NULL,
	[OrderLineId] [int] NOT NULL,
	[ShipmentTrackingNumber] [varchar](255) NOT NULL,
	[ShippingCompany] [varchar](255) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentTracker]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentTracker](
	[ShipmentTrackerId] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[ShipmentTrackerDate] [datetime] NULL,
	[ShipmentTrackerStatus] [varchar](255) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShipmentTrackerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GetOrderLinesShipmentsTracker]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[GetOrderLinesShipmentsTracker] AS
SELECT 
            sh.*,
            sht.ShipmentTrackerId,
            sht.ShipmentTrackerDate,
            sht.ShipmentTrackerStatus
            FROM Shipments sh 
            INNER JOIN ShipmentTracker sht ON sh.ShipmentId = sht.ShipmentId
GO
/****** Object:  Table [dbo].[ProductTags]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTags](
	[ProductTagId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductTagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 10/20/2023 11:52:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[OrderLineId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[SellerId] [int] NOT NULL,
	[ReviewDate] [datetime] NULL,
	[ReviewStars] [int] NOT NULL,
	[ReviewComment] [varchar](1000) NOT NULL,
	[ReviewStatus] [varchar](100) NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[OrderLines] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[OrderLines] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProductImages] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[ProductImages] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProductOptions] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[ProductOptions] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProductTags] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[ProductTags] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Sellers] ADD  CONSTRAINT [DF_Sellers_SellerUsername]  DEFAULT ('n') FOR [SellerUsername]
GO
ALTER TABLE [dbo].[Sellers] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Sellers] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Shipments] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Shipments] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ShipmentTracker] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[ShipmentTracker] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SubCategories] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[SubCategories] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Tags] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[Tags] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [FK_OrderLines_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [FK_OrderLines_Orders]
GO
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [FK_OrderLines_ProductOptions] FOREIGN KEY([ProductOptionId])
REFERENCES [dbo].[ProductOptions] ([ProductOptionId])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [FK_OrderLines_ProductOptions]
GO
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [FK_OrderLines_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [FK_OrderLines_Products]
GO
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [FK_OrderLines_ProductVariants] FOREIGN KEY([ProductVariantId])
REFERENCES [dbo].[ProductVariants] ([ProductVariantId])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [FK_OrderLines_ProductVariants]
GO
ALTER TABLE [dbo].[OrderLines]  WITH CHECK ADD  CONSTRAINT [FK_OrderLines_Sellers] FOREIGN KEY([SellerId])
REFERENCES [dbo].[Sellers] ([SellerId])
GO
ALTER TABLE [dbo].[OrderLines] CHECK CONSTRAINT [FK_OrderLines_Sellers]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[ProductImages]  WITH CHECK ADD  CONSTRAINT [FK_ProductImages_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[ProductImages] CHECK CONSTRAINT [FK_ProductImages_Products]
GO
ALTER TABLE [dbo].[ProductOptions]  WITH CHECK ADD  CONSTRAINT [FK_ProductOptions_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[ProductOptions] CHECK CONSTRAINT [FK_ProductOptions_Products]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Sellers] FOREIGN KEY([SellerId])
REFERENCES [dbo].[Sellers] ([SellerId])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Sellers]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_SubCategories] FOREIGN KEY([SubCategoryId])
REFERENCES [dbo].[SubCategories] ([SubCategoryId])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_SubCategories]
GO
ALTER TABLE [dbo].[ProductTags]  WITH CHECK ADD  CONSTRAINT [FK_ProductTags_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[ProductTags] CHECK CONSTRAINT [FK_ProductTags_Products]
GO
ALTER TABLE [dbo].[ProductTags]  WITH CHECK ADD  CONSTRAINT [FK_ProductTags_Tags] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tags] ([TagId])
GO
ALTER TABLE [dbo].[ProductTags] CHECK CONSTRAINT [FK_ProductTags_Tags]
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD  CONSTRAINT [FK_ProductVariants_ProductOptions] FOREIGN KEY([ProductOptionId])
REFERENCES [dbo].[ProductOptions] ([ProductOptionId])
GO
ALTER TABLE [dbo].[ProductVariants] CHECK CONSTRAINT [FK_ProductVariants_ProductOptions]
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD  CONSTRAINT [FK_ProductVariants_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[ProductVariants] CHECK CONSTRAINT [FK_ProductVariants_Products]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_OrderLines] FOREIGN KEY([OrderLineId])
REFERENCES [dbo].[OrderLines] ([OrderLineId])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_OrderLines]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Orders]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Sellers] FOREIGN KEY([SellerId])
REFERENCES [dbo].[Sellers] ([SellerId])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Sellers]
GO
ALTER TABLE [dbo].[Shipments]  WITH CHECK ADD  CONSTRAINT [FK_Shipments_OrderLines] FOREIGN KEY([OrderLineId])
REFERENCES [dbo].[OrderLines] ([OrderLineId])
GO
ALTER TABLE [dbo].[Shipments] CHECK CONSTRAINT [FK_Shipments_OrderLines]
GO
ALTER TABLE [dbo].[ShipmentTracker]  WITH CHECK ADD  CONSTRAINT [FK_ShipmentTracker_Shipments] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[Shipments] ([ShipmentId])
GO
ALTER TABLE [dbo].[ShipmentTracker] CHECK CONSTRAINT [FK_ShipmentTracker_Shipments]
GO
ALTER TABLE [dbo].[SubCategories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_SubCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
GO
ALTER TABLE [dbo].[SubCategories] CHECK CONSTRAINT [FK_Categories_SubCategories]
GO
USE [master]
GO
ALTER DATABASE [ELSookBase] SET  READ_WRITE 
GO
