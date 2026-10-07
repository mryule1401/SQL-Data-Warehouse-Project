/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This is stored the data from external csv.
    The performance following the actions
    - Truncates tables before load data
    - `BULK INSERT` loading the data from csv files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE  @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE
		PRINT '========================================';
		PRINT 'Loading The Bronze Layer'
		PRINT '========================================';

		Print '----------------------------------------';
		PRINT 'Loading CRM Tables'
		Print '----------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
			PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';


		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';

		Print '----------------------------------------';
		PRINT 'Loading ERP Tables'
		Print '----------------------------------------';


		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Load Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';



		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Load Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';


		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Load Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Du lieu Le Huy\D\DE doc\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------------------';

		SET @batch_end_time = GETDATE()
		PRINT '============================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT 'Total Load Duration: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '============================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE'+ ERROR_MESSAGE();
		PRINT 'ERROR NUMBER'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE'+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================';
	END CATCH
END
