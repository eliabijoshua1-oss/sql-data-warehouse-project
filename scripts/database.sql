/* 
------------------------------------------------
Create Database and Schemas
------------------------------------------------
Script purpose: 
      This script create a new database named 'DataWarehouse' after checking if it already exists.
      If the database exists, it is dropped and recorded and recreated. Additionally, the script set up three schemas
      within the database: "silver" and "gold".

WARNING:
       Running this script will drop the entire 'DataWarehouse' database if it exists.
       All data in the database will be permanently deleted. Proceed with caution
       and ensure you have proper backups before running this script.
*/

USE master;
GO

--Drop and recreate 'DataWarehouse' database
If EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
     DROP DATABASE DataWarehouse;
END;
GO

-- Create Database 'Datawarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO



