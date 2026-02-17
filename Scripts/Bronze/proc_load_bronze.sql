/*
====================================================================================
Stored Precdure: Load Bronze Layer (Source -> Bronze)
====================================================================================
Script Purpos:
  This Stored Procedure loads data into the 'bronze' schema from externale CSV files
  It performs the following actions:
    -  Truncates the bronze tables before loading data.
    -  Use the 'BLUK INSERT' command to load from CSV Files to bronze tables.

Parameters: 
    None.
  This stored procedure does not accept any parameters or return any values.
  Usage Exemple: 
      EXEC bronze.load_bronze
====================================================================================
*/
REATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    
    DECLARE @start_time DATETIME, @end_time DATETIME, @whole_batch_start_time DATETIME, @whole_batch_end_time DateTime ;
    BEGIN TRY 
        Set @whole_batch_start_time = GETDATE();
        PRINT '======================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '======================================================';
        PRINT '------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------------';
        
        SET @start_time = GETDATE();
         -- Load Data table #1: 
        PRINT   '>> Truncating Table bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info

        PRINT   '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',  --  +-------------------+                       +---------------+
            TABLOCK                 --  |   File Delimiter  |                       |   TRUNCATE    |
        );                          --  +-------------------+-------------+         +---------------+-----------------------------------+
                                    --  |           , ; | # "             |         |  Quickly delete all rows from a table, resetting  |
                                    --  +---------------------------------+         |               it to an empty state                |
                                    --                                              +---------------------------------------------------+
        SET @end_time = GETDATE() 
        PRINT '>>> The Delay for loading  Table 1 is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' second'
        PRINT '>> ---------------------------------------------------------------'
        /*
                +----------------+
                |  QUALITY CHECK |
                +----------------+------------------------------------------------------+
                |   Check that the data hase not shifted and is the correct columns     |
                +-----------------------------------------------------------------------+
        */
     
        -- Load Data table #2: 
        SET @start_time = GETDATE();
        PRINT   '>> Truncating Table bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info

        PRINT   '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

         SET @end_time = GETDATE() 
         PRINT '>>> The Delay for loading  data of table 2 is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' Second'
        PRINT '>> ---------------------------------------------------------------'

        -- Load Data table #3: 
        SET @start_time = GETDATE();
        PRINT   '>> Truncating Table bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details

        PRINT   '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE() 
        PRINT '>>> The Delay for loading  Table 3 is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' Second'
        PRINT '>> ---------------------------------------------------------------'

        PRINT '------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------------';

        -- Load Data table #4: 
        SET @start_time = GETDATE();
        PRINT   '>> Truncating Table bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12

        PRINT   '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE() 
        PRINT '>>> The Delay for loading Table 4  is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' Second'
        PRINT '>> ---------------------------------------------------------------'

        -- Load Data table #5: 
        PRINT   '>> Truncating Table bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101

        PRINT   '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE() 
        PRINT '>>> The Delay for loading Table 5 is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' Second'
        PRINT '>> ---------------------------------------------------------------'


        -- Load Data table #6: 
        SET @start_time = GETDATE();
        PRINT   '>> Truncating Table bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2

        PRINT   '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\THINKPAD\Desktop\SQL\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE() 
        PRINT '>>> The Delay for loading table 6 is  ' + CAST (DATEDIFF(second,@end_time ,@start_time) AS NVARCHAR) + ' Seconds'
        PRINT '=================================================='
        PRINT 'Loading Bronze Layer is Completed'
        SET @whole_batch_end_time = GETDATE();
        PRINT '   - Total Load Duration:  ' + CAST (DATEDIFF(second,@whole_batch_end_time ,@whole_batch_Start_time) AS NVARCHAR) + ' Seconds'
        PRINT '=================================================='
    END TRY
    BEGIN CATCH
        PRINT '==========================================='
        PRINT 'ERROR OCCURED DURING LOADING  BRONZE LAYER'
        PRINT 'Error Message ' + ERROR_MESSAGE();
        PRINT 'Error Message ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT '==========================================='
    END CATCH
END
