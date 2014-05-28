CREATE PROCEDURE SP_NORMS_ServiceTypes AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Display TABLE (DummyOrder INT IDENTITY(1,1), Service_id INT, ParentService_id INT, strService_nm VARCHAR(50))

INSERT INTO @Display
SELECT Service_id, ParentService_id, strService_nm
FROM Service
WHERE ParentService_id IS NULL

INSERT INTO @Display
SELECT Service_id, ParentService_id, strService_nm
FROM Service
WHERE ParentService_id IS NOT NULL
AND strService_nm<>'Other'
ORDER BY ParentService_id, strService_nm

INSERT INTO @Display
SELECT Service_id, ParentService_id, strService_nm
FROM Service
WHERE ParentService_id IS NOT NULL
AND strService_nm='Other'
ORDER BY ParentService_id, strService_nm

SELECT Service_id, ParentService_id, strService_nm
FROM @Display
ORDER BY ParentService_id, DummyOrder

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


