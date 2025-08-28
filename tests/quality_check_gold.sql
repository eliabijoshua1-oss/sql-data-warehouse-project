/*
**************************************************************************
Quality Checks:
**************************************************************************
Script Purpose:
     This script performs quality checks to validate the integrity, consistency 
     and accurancy of the Gold Layer. These checks ensure;
       -uniqueness of surrogate keys in dimension tables.
       -Referential integrity between fact and dimension tables.
       -Validation of relationshipin the data model for analytical purposes.

Usage:
     -Run these checks after data loading Silver Layer.
     -Investigate and resolve any problems found during the checks.
**************************************************************************
*/

****************************************************************************
---Checking: 'gold.dim_customers'
****************************************************************************
-- Check any duplicates after join
SELECT cst_id,COUNT(*) FROM (
SELECT
   ci.cst_id,
   ci.cst_key,
   ci.cst_firstname,
   ci.cst_lastname,
   ci.cst_material_status,
   ci.cst_gender,
   ci.cst_create_date,
   ca.bdate,
   ca.gen,
   la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON          ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON           ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) > 1

--not duplicates
  SELECT DISTINCT 
   ci.cst_gender,
   ca.gen, 
   CASE WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender   --- CRM is the master for gender info
        ELSE COALESCE(ca.gen, 'n/a')
   END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON          ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON           ci.cst_key = la.cid
ORDER BY 1,2

**********************************************************************************
--- Ckecking: 'gold.dim_products'
**********************************************************************************
SELECT prd_key, COUNT(*) FROM (
SELECT
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pn.prd_end_dt,
pc.cat,
pc.subcat,
pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL --Filter out all historical data
)t GROUP BY prd_key
HAVING COUNT(*) > 1


*******************************************************************************
---Checking: 'gold.fact_sales'
********************************************************************************
----Foreign Key Integrity (Dimensions)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_number IS NULL
WHERE p.product_number IS NULL
