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
