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
 CREATE SCHEMA bronze;      -- Create the first Schema bronze
 GO
 CREATE SCHEMA silver;      -- Create the Second Schema Silver

 GO                         --  Go: Separate batches when working with multiple SQL statements

 CREATE SCHEMA gold;        -- Create the thired Schema Gold
 GO
