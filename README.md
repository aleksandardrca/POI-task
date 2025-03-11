## Description

SQL server stored procedure which will find POIs 

## Input for stored procedure

Criteria should be passed to the stored procedure in JSON format as one input parameter
</br>
Some criteria, or even all of them, may be omitted from the input JSON
</br>
List of criteria:
</br>
1. country_code 
2. region
3. city
4. coordinates.latitude
5. coordinates.longitude
6. coordinates.radius
7. polygon_wkt
8. category
9. location_name
</br>


<b>Format of JSON Request with all criteria passed</b>

```
'{
	"Request":
	{
		"country_code": "US",
		"region": "AZ",
		"city": "Phoenix",
		"coordinates":
			{
				"latitude":33.674342,
				"longitude":-111.985707,
				"radius": 200
			},
		"polygon_wkt": "POLYGON ((-111.98536636499995 33.674361944000054, -111.98536609599995 33.67427466500004, -111.98544754899996 33.67427449400003, -111.98544690799997 33.67406636800007, -111.98585417499999 33.67406551500005, -111.98585620499995 33.67472346400007, -111.98545708099999 33.67472430000004, -111.98545596299999 33.67436175600005, -111.98536636499995 33.674361944000054))",
		"category": "Offices of Physicians",
		"location_name": "John Julius DO"
	}
}'
```


 If no search criteria is supplied,return all POIs within 200 meters of the current location
</br>
Dummy location:
</br>
Latitude: 33.476791
</br>
Longitude: -112.069019	
</br>
City: Phoenix
</br>
Region: AZ
</br>



### Output of stored procedure

Stored procedure is using output parameter to return data in valid GeoJSON format compressed by SQL Server.
</br>

<b>GeoJson result</b>

```
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -111.985707,
          33.674342
        ]
      },
      "properties": {
        "id": "zzw-22h@5zb-x5b-47q",
        "country_code": "US",
        "region_code": "AZ",
        "city": "Phoenix",
        "longitude": -111.985707,
        "latitude": 33.674342,
        "category": "Offices of Physicians",
        "sub_category": "Offices of Physicians (except Mental Health Specialists)",
        "polygon_wkt": "POLYGON ((-111.98536636499995 33.674361944000054, -111.98536609599995 33.674274665000041, -111.98544754899996 33.674274494000031, -111.98544690799997 33.674066368000069, -111.98585417499999 33.674065515000052, -111.98585620499995 33.674723464000067, -111.98545708099999 33.674724300000037, -111.98545596299999 33.674361756000053, -111.98536636499995 33.674361944000054))",
        "location_name": "John Julius DO",
        "postal_code": 85050
      }
    }
  ]
}
```

<b>GeoJson result when no criteria is passed or when exception is thrown</b>

```
{'type': 'FeatureCollection', 'features': []}
```


## Execution of stored procedure

```

USE [POI]
GO

DECLARE	@return_value int,
		@GeoJsonResponse nvarchar(max)

EXEC	@return_value = [dbo].[spGetPOI]
		@JsonRequest = '{
	"Request":
	{
		"country_code": "US",
		"region": "AZ",
		"city": "Phoenix",
		"coordinates":
			{
				"latitude":33.674342,
				"longitude":-111.985707,
				"radius": 200
			},
		"polygon_wkt": "POLYGON ((-111.98536636499995 33.674361944000054, -111.98536609599995 33.67427466500004, -111.98544754899996 33.67427449400003, -111.98544690799997 33.67406636800007, -111.98585417499999 33.67406551500005, -111.98585620499995 33.67472346400007, -111.98545708099999 33.67472430000004, -111.98545596299999 33.67436175600005, -111.98536636499995 33.674361944000054))",
		"category": "Offices of Physicians",
		"location_name": "John Julius DO"
	}
}',
@GeoJsonResponse = @GeoJsonResponse OUTPUT

SELECT	@GeoJsonResponse as N'@GeoJsonResponse'

```

### Database backup and instructions

Full database backup and instructions
</br>
Task.zip


## Author

Aleksandar Drca
</br>
Email: aleksandardrca@gmail.com


## Version History

* 0.1
    * Initial Release

