USE [POI]
GO
/****** Object:  StoredProcedure [dbo].[spGetPOI]    Script Date: 11.3.2025. 11:20:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetPOI] 
	@JsonRequest NVARCHAR(MAX),
	@GeoJsonResponse NVARCHAR(MAX) OUTPUT
AS
BEGIN


	DECLARE @GeoJsonFeature NVARCHAR(MAX)
	DECLARE @GeoJsonFeatureColl NVARCHAR(MAX)
	DECLARE @CountryCode NVARCHAR(2)
	DECLARE @RegionCode NVARCHAR(2)
	DECLARE @CityName NVARCHAR(100)
	DECLARE @Latitude DECIMAL(8,6)
	DECLARE @Longitude DECIMAL(9,6)
	DECLARE @Radius INT
	DECLARE @PolygonWkt GEOMETRY
	DECLARE @Polygon GEOGRAPHY
	DECLARE @GeoPoint GEOGRAPHY
	DECLARE @CategoryName NVARCHAR(100)
	DECLARE @LocationName NVARCHAR(255)

	DECLARE @Conditions BIT

	DECLARE @Dummy GEOGRAPHY = geography::Point(33.476791, -112.069019, 4326) -- Dummy location

	SET NOCOUNT ON;

	BEGIN TRY
  
		--Request
		BEGIN

					SELECT	@CountryCode = json.CountryCode,
							@RegionCode = json.RegionCode,
							@CityName = json.CityName,
							@Longitude = json.Longitude,
							@Latitude = json.Latitude,
							@Radius = json.Radius,
							@PolygonWkt = json.PolygonWkt,
							@CategoryName = json.CategoryName,
							@LocationName = json.LocationName
					FROM OPENJSON(@JsonRequest, '$.Request') 
						 WITH (CountryCode NVARCHAR(2) '$.country_code',
							   RegionCode NVARCHAR(2) '$.region',
							   CityName NVARCHAR(100) '$.city',
							   Longitude DECIMAL(9,6) '$.coordinates.longitude',
							   Latitude DECIMAL(8,6) '$.coordinates.latitude',
							   Radius INT '$.coordinates.radius',
							   PolygonWkt NVARCHAR(MAX) '$.polygon_wkt',
							   CategoryName NVARCHAR(100) '$.category',
							   LocationName NVARCHAR(255) '$.location_name') json

		END

		--Check conditions
		BEGIN

					SET @Conditions = (CASE
									   WHEN @CountryCode IS NULL AND
											@RegionCode IS NULL AND
											@CityName IS NULL AND
											@Latitude IS NULL AND
											@Longitude IS NULL AND
											@Radius IS NULL AND
											@PolygonWkt IS NULL AND
											@CategoryName IS NULL AND
											@LocationName IS NULL 
									   THEN 0
									   ELSE 1
									   END ) 

		END

		--If conditions are met get location
		IF @Conditions = 1
			BEGIN	
			
				IF @Latitude IS NOT NULL 
					AND 
				   @Longitude IS NOT NULL 
					AND 
				   @Radius IS NOT NULL
						BEGIN
							SET @GeoPoint = geography::Point(@Latitude,@Longitude, 4326)
						END	
			
				IF @PolygonWkt IS NOT NULL
						BEGIN
							SET @Polygon = @PolygonWkt.MakeValid().STUnion(@PolygonWkt.STStartPoint()).STAsText() -- Fixing Polygon Ring Orientation problem
						END

				DECLARE @SQL NVARCHAR(MAX) = 'SELECT @GeoJsonFeature = ( select
															''Feature'' AS [type],
															JSON_QUERY(dbo.fnGeometryToJSON(geometry::Point(loc.Longitude,loc.Latitude,4326))) AS [geometry],
															loc.LocationId AS ''properties.id'',
															loc.LocationParentID AS ''properties.parent_id'',
															ctr.CountryCode AS ''properties.country_code'',
															reg.RegionCode AS ''properties.region_code'',
															cty.CityName AS ''properties.city'',
															loc.Longitude AS ''properties.longitude'',
															loc.Latitude AS ''properties.latitude'',
															cat1.CategoryName AS ''properties.category'',
															cat2.CategoryName AS ''properties.sub_category'',
															loc.PolygonWkt.ToString() AS ''properties.polygon_wkt'',
															loc.LocationName AS ''properties.location_name'',
															loc.PostalCode AS ''properties.postal_code'',
															(SELECT [Day] AS ''day'',
																	''[["'' + CONVERT(VARCHAR(5), OpenTime, 108) + ''", "'' + CONVERT(VARCHAR(5), closetime, 108) + ''"]]'' AS ''hours''			
																FROM LocationOperationHour
																WHERE LocationID = loc.LocationID
																FOR JSON PATH) AS ''properties.operation_hours''
														FROM Location loc
														JOIN City cty ON cty.CityID = loc.CityID
														JOIN CityRegions cr on cty.CityID = cr.CityId
														JOIN Region reg ON reg.RegionID = cr.RegionID
														JOIN Country ctr ON ctr.CountryID = reg.CountryID
														LEFT JOIN LocationCategory lc on lc.LocationID = loc.LocationID
														LEFT JOIN LocationSubcategory lsc on lc.LocationID = lsc.LocationID
														LEFT JOIN Category cat1 ON cat1.CategoryID = lc.CategoryID
														LEFT JOIN Category cat2 ON cat2.CategoryID =lsc.SubCategoryID
																				WHERE 1=1'; 

							IF @CountryCode IS NOT NULL
								SET @SQL = @SQL + ' AND ctr.CountryCode = @CountryCode';

							IF @RegionCode IS NOT NULL
								SET @SQL = @SQL + ' AND reg.RegionCode = @RegionCode';

							IF @CityName IS NOT NULL
								SET @SQL = @SQL + ' and cty.CityName LIKE ''%'' + @CityName + ''%''';
					
							IF @GeoPoint IS NOT NULL
								SET @SQL = @SQL + ' and (loc.GeoPoint.STDistance(@GeoPoint)) <= @Radius';

							IF @Polygon IS NOT NULL
								SET @SQL = @SQL + ' and @Polygon.STIntersects(loc.GeoPoint) = 1';

							IF @CategoryName IS NOT NULL
								SET @SQL = @SQL + ' and cat1.CategoryName = @CategoryName ';

							IF @LocationName IS NOT NULL
								SET @SQL = @SQL + ' and loc.LocationName = @LocationName ';

								set @SQL = @SQL + 'FOR JSON PATH)';
					

							EXEC sp_executesql @SQL, N'@CountryCode NVARCHAR(2), @RegionCode NVARCHAR(2), @CityName NVARCHAR(100), @GeoPoint GEOGRAPHY, @Radius INT, @Polygon GEOGRAPHY, @CategoryName NVARCHAR(100), @LocationName NVARCHAR(255), @GeoJsonFeature NVARCHAR(MAX) OUTPUT', 
													@CountryCode, 
													@RegionCode,
													@CityName, 
													@GeoPoint, 
													@Radius, 
													@Polygon, 
													@CategoryName, 
													@LocationName,  
													@GeoJsonFeature OUTPUT;
			

			END
		ELSE
			-- No conditions -- dummy location
			BEGIN

				SET @GeoJsonFeature = 
					(
						SELECT	
							'Feature' AS [type],
							JSON_QUERY(dbo.fnGeometryToJSON(geometry::Point(loc.Longitude,loc.Latitude,4326))) AS [geometry],
							loc.LocationId AS 'properties.id',
							loc.LocationParentID AS 'properties.parent_id',
							ctr.CountryCode AS 'properties.country_code',
							reg.RegionCode AS 'properties.region_code',
							cty.CityName AS 'properties.city',
							loc.Longitude AS'properties.longitude',
							loc.Latitude AS 'properties.latitude',
							cat1.CategoryName AS 'properties.category',
							cat2.CategoryName AS 'properties.sub_category',
							loc.PolygonWkt.ToString() AS 'properties.polygon_wkt',
							loc.LocationName AS 'properties.location_name',
							loc.PostalCode AS 'properties.postal_code',
							(SELECT [Day] AS 'day',
									'[["' + CONVERT(VARCHAR(5), OpenTime, 108) + '", "' + CONVERT(VARCHAR(5), closetime, 108) + '"]]' AS 'hours'           
								FROM LocationOperationHour
								WHERE LocationID = loc.LocationID
								FOR JSON PATH) AS 'properties.operation_hours'
						FROM Location loc
							JOIN City cty ON cty.CityID = loc.CityID
							JOIN CityRegions cr on cty.CityID = cr.CityId
							JOIN Region reg ON reg.RegionID = cr.RegionID
							JOIN Country ctr ON ctr.CountryID = reg.CountryID
							LEFT JOIN LocationCategory lc on lc.LocationID = loc.LocationID
							LEFT JOIN LocationSubcategory lsc on lc.LocationID = lsc.LocationID
							LEFT JOIN Category cat1 ON cat1.CategoryID = lc.CategoryID
							LEFT JOIN Category cat2 ON cat2.CategoryID =lsc.SubCategoryID
						WHERE loc.GeoPoint.STDistance(@Dummy) <= 200
						FOR JSON PATH
					)
			END
		
		--return geojson
		BEGIN
			IF @GeoJsonFeature <> ''
				BEGIN
					SET @GeoJsonFeatureColl = (SELECT 'FeatureCollection' AS [type],JSON_QUERY(@GeoJsonFeature) AS 'features' FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
				END
			ELSE
				BEGIN
					SET @GeoJsonFeatureColl = '{''type'': ''FeatureCollection'', ''features'': []}'
				END
		END

END TRY
BEGIN CATCH
	SET @GeoJsonFeatureColl = '{''type'': ''FeatureCollection'', ''features'': []}'
END CATCH;

SET @GeoJsonResponse = @GeoJsonFeatureColl

END

GO
