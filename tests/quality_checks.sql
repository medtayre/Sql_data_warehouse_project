/*
==============================================================================
Quality Checks
==============================================================================
Script Purpos: 
  This Script performs quality checks to validate the integrity , consistency,
  and accuracy of the gold layey. These checks ensure:
  -  Uniqueness of surrogate keys in dimension tables.
  -  Referential integrity between fact and dimension tables.
  -  Validation of relationships in the data model for analytical purposes.

Usage Notes: 
  - Run these checks after data loading Silver Layer.
  -  Investigate and resolve any descrepanicies found during the checks.
==============================================================================
*/

--============================================================================
-- Checking 'gold.dim_customers'
--============================================================================
--Check for uniqueness of Customer Key in gold.dim_customers
--  Expectation: No results.
SELECT
  customer_key,
  COUNT(*) As dublicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1; 

--============================================================================
