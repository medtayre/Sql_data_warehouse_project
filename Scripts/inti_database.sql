/*
======================================================================================================
 Create Database and Schemas
======================================================================================================
 Script Purpose 
       This script creates a new database named 'DataWarehouse' after checking if it already exists.
       if the database exists, it is dropped and recreated. Additionally, the Script sets up three Schemas 
       Within the database: 'bronze', 'silver', and 'gold'.

WARNING:
       Running this script will drop the entire 'DataWarehouse' database if it exists.
       All data in the database will be prementaly deleted. Proceed with Caution
       and ensure you have proper backups before running this script.
*/

Use master;         --             Swith to master 
   GO
 
 -- Drop and recreate the 'DataWarehouse' database
 IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
 BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
    DROP DATABASE DataWerhouse; 
END;
GO

-- Create the 'DataWarehouse' database
 CREATE DATABASE DataWerhouse;
 GO

 USE DataWerhouse; 
 GO
  
-- Create Schemas 
 CREATE SCHEMA bronze;      -- Create the first Schema bronze
 GO
  
 CREATE SCHEMA silver;      -- Create the Second Schema Silver
 GO                         --  Go: Separate batches when working with multiple SQL statements

 CREATE SCHEMA gold;        -- Create the thired Schema Gold
 GO
