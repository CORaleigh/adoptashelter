# adoptashelter
City of Raleigh Shelter Adoption app  
##Requirements
1. [PostgreSQL](https://www.postgresql.org) database with [PostGIS](http://www.postgis.net) extension  
2. [PHP](https://www.php.net) with [PDO PostgresSQL](http://php.net/manual/en/ref.pdo-pgsql.php) extension  

##Database Setup  
After installing PGSQL and PostGIS:  
1. Create new database called **adopt**  
2. Add a new user called **adopt** with password **adopt**  
3. Run following command using **db/adopt.sql** file: 
    psql -d adopt -U adopt -f <**path to adopt.sql**>  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*note that this will load the GoRaleigh shelters into the database*  

##API  
The API is based off of v1 of [tobinbradley's](https://github.com/tobinbradley)  [dirt-simple-postgis-http-api](https://github.com/tobinbradley/dirt-simple-postgis-http-api/tree/v1)  
1. [api/v1/ws_bus_shelter_adopt.php](https://github.com/CORaleigh/adoptashelter/blob/master/api/v1/ws_bus_shelter_adopt.php) script handles adding adopters to the shelters  
2. [api/v1/ws_geo_attributequery.php](https://github.com/CORaleigh/adoptashelter/blob/master/api/v1/ws_geo_attributequery.php) script retrieves shelters as GeoJSON from the PostGIS database  
3. [api/inc/database.inc.txt](https://github.com/CORaleigh/adoptashelter/blob/master/api/inc/database.inc.txt) stores the database connection information
