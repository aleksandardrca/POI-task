USE [POI]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[ParentCategoryID] [int] NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryCategoryTag]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryCategoryTag](
	[CategoryCategoryTag] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[CategoryTagID] [int] NOT NULL,
 CONSTRAINT [PK_CategoryCategoryTag] PRIMARY KEY CLUSTERED 
(
	[CategoryCategoryTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryTag]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryTag](
	[CategoryTagID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryTagName] [nvarchar](200) NULL,
 CONSTRAINT [PK_CategoryTag] PRIMARY KEY CLUSTERED 
(
	[CategoryTagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[CityName] [nvarchar](100) NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CityRegions]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CityRegions](
	[CityRegionsID] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
 CONSTRAINT [PK_CityRegions] PRIMARY KEY CLUSTERED 
(
	[CityRegionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [nvarchar](2) NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocationID] [nvarchar](50) NOT NULL,
	[LocationParentID] [nvarchar](50) NULL,
	[CategoryID] [int] NULL,
	[CityID] [int] NULL,
	[LocationName] [nvarchar](255) NOT NULL,
	[PostalCode] [int] NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[PolygonWkt] [geography] NULL,
	[GeoPoint]  AS ([geography]::Point([Latitude],[Longitude],(4326))) PERSISTED,
 CONSTRAINT [PK_PointOfInterest] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationCategory]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationCategory](
	[LocationCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [nvarchar](50) NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_LocationCategory] PRIMARY KEY CLUSTERED 
(
	[LocationCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationOperationHour]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationOperationHour](
	[LocationOperationHourID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [nvarchar](50) NULL,
	[Day] [nvarchar](3) NULL,
	[OpenTime] [time](7) NULL,
	[CloseTime] [time](7) NULL,
 CONSTRAINT [PK_LocationOperationHours] PRIMARY KEY CLUSTERED 
(
	[LocationOperationHourID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationSubCategory]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationSubCategory](
	[LocationSubCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [nvarchar](50) NOT NULL,
	[SubCategoryID] [int] NOT NULL,
 CONSTRAINT [PK_LocationSubCategory] PRIMARY KEY CLUSTERED 
(
	[LocationSubCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Region]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Region](
	[RegionID] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NULL,
	[RegionCode] [nvarchar](2) NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stgTbl]    Script Date: 10.3.2025. 23:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stgTbl](
	[id] [nvarchar](500) NOT NULL,
	[parent_id] [nvarchar](500) NULL,
	[brand] [nvarchar](500) NULL,
	[brand_id] [nvarchar](500) NULL,
	[top_category] [nvarchar](500) NULL,
	[sub_category] [nvarchar](500) NULL,
	[category_tags] [nvarchar](500) NULL,
	[postal_code] [int] NULL,
	[location_name] [nvarchar](500) NULL,
	[latitude] [nvarchar](100) NULL,
	[longitude] [nvarchar](100) NULL,
	[country_code] [nvarchar](500) NULL,
	[city] [nvarchar](500) NULL,
	[region] [nvarchar](500) NULL,
	[operation_hours] [nvarchar](500) NULL,
	[geometry_type] [nvarchar](50) NULL,
	[polygon_wkt] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CategoryCategoryTag]  WITH CHECK ADD  CONSTRAINT [FK_CategoryCategoryTag_CategoryID] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[CategoryCategoryTag] CHECK CONSTRAINT [FK_CategoryCategoryTag_CategoryID]
GO
ALTER TABLE [dbo].[CategoryCategoryTag]  WITH CHECK ADD  CONSTRAINT [FK_CategoryCategoryTag_CategoryTagID] FOREIGN KEY([CategoryTagID])
REFERENCES [dbo].[CategoryTag] ([CategoryTagID])
GO
ALTER TABLE [dbo].[CategoryCategoryTag] CHECK CONSTRAINT [FK_CategoryCategoryTag_CategoryTagID]
GO
ALTER TABLE [dbo].[CityRegions]  WITH CHECK ADD  CONSTRAINT [FK_City_Regions_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[CityRegions] CHECK CONSTRAINT [FK_City_Regions_CityId]
GO
ALTER TABLE [dbo].[CityRegions]  WITH CHECK ADD  CONSTRAINT [FK_City_Regions_RegionId] FOREIGN KEY([RegionId])
REFERENCES [dbo].[Region] ([RegionID])
GO
ALTER TABLE [dbo].[CityRegions] CHECK CONSTRAINT [FK_City_Regions_RegionId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_CategoryID] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_Location_CategoryID]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_CityID] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([CityID])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_Location_CityID]
GO
ALTER TABLE [dbo].[LocationCategory]  WITH CHECK ADD  CONSTRAINT [FK_LocationCategory_CategoryID] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[LocationCategory] CHECK CONSTRAINT [FK_LocationCategory_CategoryID]
GO
ALTER TABLE [dbo].[LocationCategory]  WITH CHECK ADD  CONSTRAINT [FK_LocationCategory_LocationID] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])
GO
ALTER TABLE [dbo].[LocationCategory] CHECK CONSTRAINT [FK_LocationCategory_LocationID]
GO
ALTER TABLE [dbo].[LocationOperationHour]  WITH CHECK ADD  CONSTRAINT [FK_LocationOperationHours_LocationID] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])
GO
ALTER TABLE [dbo].[LocationOperationHour] CHECK CONSTRAINT [FK_LocationOperationHours_LocationID]
GO
ALTER TABLE [dbo].[LocationSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_LocationCategory_SubCategoryID] FOREIGN KEY([SubCategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[LocationSubCategory] CHECK CONSTRAINT [FK_LocationCategory_SubCategoryID]
GO
ALTER TABLE [dbo].[LocationSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_LocationSubCategory_LocationID] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Location] ([LocationID])
GO
ALTER TABLE [dbo].[LocationSubCategory] CHECK CONSTRAINT [FK_LocationSubCategory_LocationID]
GO
ALTER TABLE [dbo].[Region]  WITH CHECK ADD  CONSTRAINT [FK_Region_CountryID] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Region] CHECK CONSTRAINT [FK_Region_CountryID]
GO
