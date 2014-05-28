--Modified 10/8/08 MWB
--Added qstncore to grouping for nested sql b/c QDE panel counts comments and this procedure only
--counted form_ID (litho codes) so counts were mismatching in the same same program.
CREATE PROCEDURE SP_QDE_CurrentCounts      
AS      
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
      
SELECT SUM(ToBeKeyed) ToBeKeyed, SUM(tobekeyverified) ToBeKeyVerified, SUM(tobecoded) ToBeCoded, SUM(tobecodeverified) ToBeCodeVerified, SUM(tobefinalized) ToBeFinalized      
FROM (SELECT f.Form_id, qstncore, CASE WHEN strKeyedBy IS NULL THEN 1 ELSE 0 END ToBeKeyed, CASE WHEN strKeyVerifiedBy IS NULL AND strKeyedBy IS NOT NULL THEN 1 ELSE 0 END ToBeKeyVerified,       
CASE WHEN strCodedBy IS NULL AND strKeyVerifiedBy IS NOT NULL THEN 1 ELSE 0 END ToBeCoded, CASE WHEN strCodeVerifiedBy IS NULL AND strCodedBy IS NOT NULL THEN 1 ELSE 0 END ToBeCodeVerified,      
CASE WHEN strCodeVerifiedBy IS NOT NULL THEN 1 ELSE 0 END AS ToBeFinalized      
FROM QDEForm f, QDEComments c, QDEBatch b      
WHERE f.Batch_id=b.Batch_id      
AND b.datFinalized IS NULL      
AND f.Form_id=c.Form_id      
AND c.bitIgnore = 0  
GROUP BY f.Form_id, qstncore, strKeyedBy, strKeyVerifiedBy, strCodedBy, strCodeVerifiedBy) a


