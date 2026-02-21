/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy,
  and standarization across the 'silver' schema. It includes checks for:
  -  Null our duplicate primary Keys.
  -  Unwanted Spaces in String Field.
  -  Data Standarization and consistency.
  -  Invalid data ranges and orders.
  -  Data consistency between related fields.

Usage Notes:
    -  Run thes checks after data loading Silver Layer.
    -  Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

--==============================================================================
--  Checking 'silver .crm_cust_info'
--==============================================================================
-- Check for NULLs or Duplicates in Primary Key 
-- Expectation: No Results

SELECT 
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL ; 

-- Check for Unwanted Spaces 
-- Expectation: No Results
SELECT 
  cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standarization & Consistency 
SELECT DISTINCT 
  cst_marital-status
FROM silver.crm_cust_info;

--==============================================================================
--  Checking 'silver .crm_prd_info'
--==============================================================================
-- Check for NULLs or Duplicates in Primary Key 
-- Expectation: No Results
SELECT 
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL 

-- Check for Unwanted Spaces 
-- Expectation: No Results
SELECT 
  prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
SELECT 
  prd_cost
FROM silver.crm_prd_info
WHERE  prd_cost < 0 OR prc_cust IS NULL  ;

-- Data Standarization & Consistency
SELECT DISTINCT 
  prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date
-- Expectation: No Results
SELECT 
  *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_statr_dt

--==============================================================================
--  Checking 'silver .crm_sales_details'
--==============================================================================
-- Check for invalide Dates
-- Expectation: No Invalid Dates
SELECT 
  NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Check for invalide Dates Orders (Order Date > Shipping Date  / Due Dates ) 
-- Expectation: No results
SELECT 
  *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No results
SELECT DISTINCT 
  sls_sales,
  sls_quantity,
  sls_price
FROM Silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL 
    OR sls_quantity IS NULL 
    OR sls_price IS NULL 
    OR sls_sales  <= 0
    OR sls_quantity  <= 0
    OR sls_price  <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

--==============================================================================
--  Checking 'silver.erp_cust_az12'
--==============================================================================
-- Identify Out-of-Range Dates 
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT 
  bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Data Standarization & Consistency
SELECT DISTINCT 
  gen
FROM silver.erp_cust_az12
  
--==============================================================================
--  Checking 'silver.erp_loc_a101'
--==============================================================================
  -- Data Standarization & Consistency 
  SELECT DISTINCT 
    cntry
  FROM silver.erp_loc_a101
  ORDER BY cntry;

--==============================================================================
--  Checking 'silver.erp_px_cat_g1v2'
--==============================================================================
--  Check for unwanted Spaces 
-- Excepctation: No Results 
SELECT 
  *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance  != TRIM(maintenance);

-- Data Standarizations & Consistency 
SELECT DISTINCT 
  maintenance 
FROM silver.erp_px_catg1v2
