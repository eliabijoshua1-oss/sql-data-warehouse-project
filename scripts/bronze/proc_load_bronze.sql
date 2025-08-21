/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
     None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
     EXEC bronze.load_bronze;
=================================================================================
*/

CREATE  OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
  SET @batch_start_time = GETDATE();
  BEGIN TRY
    PRINT '==========================================';
    PRINT 'Loading Bronze Layer';
    PRINT '==========================================';

    PRINT '------------------------------------------';
    PRINT 'Loading CRM Tables';
    PRINT '------------------------------------------';
    
    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.crm_cust_info ';
    TRUNCATE TABLE bronze.crm_cust_info;
    
    PRINT '>> Inserting Data Into:bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\USER\AppData\Local\Temp\9c64ffc8-dfce-4539-a556-20b572413ffb_sql-data-warehouse-project.zip.ffb\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
    PRINT '>> ----------------'

    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.crm_prd_info ';
    TRUNCATE TABLE bronze.crm_prd_info;
    
    PRINT '>> Inserting Data Into:bronze.crm_prd_info';
    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\USER\AppData\Local\Temp\2c548692-7da8-4a03-95a2-f5421bcdc718_sql-data-warehouse-project.zip.718\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
    PRINT '>> -----------------'

    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    
    PRINT '>> Inserting Data Into:bronze.crm_sales_details';
    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\USER\AppData\Local\Temp\9d6d1d51-6de0-45f3-b0fe-1e65fa16bcd4_sql-data-warehouse-project.zip.cd4\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
    PRINT '>> -----------------'
    
    PRINT '------------------------------------------';
    PRINT 'Loading ERP Tables';
    PRINT '------------------------------------------';
    
    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.erp_cust_az12 ';
    TRUNCATE TABLE bronze.erp_cust_az12;
    
    PRINT '>> Inserting Data Into:bronze.erp_cust_az12';
    BULK INSERT bronze.erp_cust_az12
    FROM 'C:\Users\USER\AppData\Local\Temp\603c6de6-3161-4986-a2bf-33bb32fda20b_sql-data-warehouse-project.zip.20b\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
    PRINT '>> -----------------'
    
    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.erp_loc_a101 ';
    TRUNCATE TABLE bronze.erp_loc_a101;
    
    PRINT '>> Inserting Data Into:bronze.erp_loc_a101';
    BULK INSERT bronze.erp_loc_a101
    FROM 'C:\Users\USER\AppData\Local\Temp\98d73268-d689-4ee0-a32c-13a927c57da5_sql-data-warehouse-project.zip.da5\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
    PRINT '>> -----------------'
    
    SET @start_time = GETDATE();
    PRINT '>>Truncating Table:bronze.erp_px_cat_g1v2 ';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    
    PRINT '>> Inserting Data Into:bronze.erp_px_cat_g1v2';
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'C:\Users\USER\AppData\Local\Temp\722b15e2-1c3b-4cfb-9666-0041caa402c1_sql-data-warehouse-project.zip.2c1\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
    PRINT '>> -----------------'

    SET @batch_end_time = GETDATE();
    PRINT '==========================================';
    PRINT 'Loading Bronze Layer is Complete';
    PRINT '   -Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
    PRINT '=========================================='
  END TRY
  BEGIN CATCH
    PRINT '--------------------------------------';
    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    PRINT 'Error Message' + ERROR_MESSAGE();
    PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
    PRINT '--------------------------------------';
  END CATCH
END
