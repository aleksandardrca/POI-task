USE [POI]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGeometryToJSON]    Script Date: 10.3.2025. 23:40:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGeometryToJSON] (@geo GEOMETRY)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @GeoJSON NVARCHAR(MAX)
	DECLARE @GeoType NVARCHAR(MAX)

    IF @geo IS NOT NULL
    BEGIN
	    set @GeoType = @geo.STGeometryType()
        SET @GeoJSON = 
            '{"type": "' + @GeoType +'","coordinates":[' + 
            FORMAT(@geo.STX, 'N6') + ',' + 
            FORMAT(@geo.STY, 'N6') + ']}'
    END
    ELSE
    BEGIN
        SET @GeoJSON = 'null'
    END

    RETURN @GeoJSON
END

GO
