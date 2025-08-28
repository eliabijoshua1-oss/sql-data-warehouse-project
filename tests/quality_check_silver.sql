/*
------------------------------------------------------------------
Quality Checks
------------------------------------------------------------------
Script Purpose:
      This script performs various quality checks for data consistency, accuracy,
      and standardization across the 'silver' schemas. It includes checks for:
      - Null or duplicate primary keys.
      - Unwanted spaces in string fields.
      - Data standardization and consistency.
      - Invalid date ranges and orders.
      - Data consistency between related fields.

Usage Notes:
      - Run these checks after data loading Silver layer.
      - Investigate and resolve any discrepancies found during the checks.
---------------------------------------------------------------------
*/

--Data Standardization & Consistency
SELECT *
FROM silver.crm_cust_info

---Identify Out-of-Range Dates

SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Check unwanted spaces
--- Expectation: No Results 
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE  cst_firstname ! = TRIM (cst_firstname)

--- Check null or duplicates
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
