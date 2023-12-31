USE [master]
GO
/****** Object:  Database [ELSookBase]    Script Date: 6/28/2023 3:19:39 PM ******/
CREATE DATABASE [ELSookBase]
GO
USE [ELSookBase]
GO
/****** Object:  Sequence [dbo].[ShipmentTrackerNumberSeq]    Script Date: 6/28/2023 3:19:39 PM ******/
CREATE SEQUENCE [dbo].[ShipmentTrackerNumberSeq] 
 AS [int]
 START WITH 10000000
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 99999999
 CACHE 
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TagsTreeView]    Script Date: 6/28/2023 3:19:39 PM ******/
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
/****** Object:  Table [dbo].[Categories]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](255) NOT NULL,
	[CategoryDescription] [varchar](1000) NOT NULL,
	[CategoryStatus] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubCategories]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[SubCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GetCategoriesDetails]    Script Date: 6/28/2023 3:19:39 PM ******/
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
/****** Object:  Table [dbo].[Sellers]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[SellerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductOptions]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductOptions](
	[ProductOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductOptionName] [varchar](255) NOT NULL,
	[ProductOptionStatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariants]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[ProductVariantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductImages]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductImages](
	[ProductImageId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductImagePath] [varchar](1000) NOT NULL,
	[ProductImageType] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderLines]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[OrderLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CustomersOrders]    Script Date: 6/28/2023 3:19:39 PM ******/
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
/****** Object:  Table [dbo].[Customers]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SellersOrders]    Script Date: 6/28/2023 3:19:39 PM ******/
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
	po.ProductOptionName,
	pv.ProductVariantName,
	pv.ProductVariantUnit,
	pi.ProductImagePath,
	pi.ProductImageType
from OrderLines ol
inner join Orders o on o.OrderId = ol.OrderId
inner join Products p on p.ProductId = ol.ProductId
inner join ProductOptions po on po.ProductId = p.ProductId
inner join ProductVariants pv on pv.ProductId = p.ProductId and pv.ProductOptionId = po.ProductOptionId
inner join ProductImages pi on pi.ProductId = p.ProductId
inner join Customers c on c.CustomerId = o.CustomerId
GO
/****** Object:  View [dbo].[CartProductDetails]    Script Date: 6/28/2023 3:19:39 PM ******/
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
/****** Object:  Table [dbo].[Shipments]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipments](
	[ShipmentId] [int] IDENTITY(1,1) NOT NULL,
	[OrderLineId] [int] NOT NULL,
	[ShipmentTrackingNumber] [varchar](255) NOT NULL,
	[ShippingCompany] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentTracker]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentTracker](
	[ShipmentTrackerId] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[ShipmentTrackerDate] [datetime] NULL,
	[ShipmentTrackerStatus] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShipmentTrackerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GetOrderLinesShipmentsTracker]    Script Date: 6/28/2023 3:19:39 PM ******/
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
/****** Object:  Table [dbo].[ProductTags]    Script Date: 6/28/2023 3:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTags](
	[ProductTagId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductTagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 6/28/2023 3:19:39 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[ReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sellers] ADD  CONSTRAINT [DF_Sellers_SellerUsername]  DEFAULT ('n') FOR [SellerUsername]
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
