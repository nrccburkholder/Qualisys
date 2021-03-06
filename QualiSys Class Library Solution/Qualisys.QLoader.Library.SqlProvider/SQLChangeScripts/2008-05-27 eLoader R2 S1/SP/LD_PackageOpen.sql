USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_PackageOpen]    Script Date: 03/27/2008 16:44:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_PackageOpen] @strLogin_nm VARCHAR(42), @bitNew BIT=0  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DECLARE @sql VARCHAR(8000), @strLoadingDest VARCHAR(200)

SELECT @strLoadingDest=strParam_Value FROM Loading_Params WHERE strParam_nm='Loading Destination'  
  
CREATE TABLE #ClientList (  
 strClient_nm   VARCHAR(42),  
 Client_id   INT,  
 strStudy_nm   VARCHAR(42),  
 Study_id   INT  
)  
  
SET @sql='INSERT INTO #ClientList  
EXEC '+@strLoadingDest+'SP_SYS_ClientList '''+@strLogin_nm+''''
EXEC (@sql)
  
IF @bitNew=0  
  
/*  
SELECT t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
  p.strPackage_nm, p.Package_id, MAX(p.intVersion)  
 FROM #ClientList t, Package P  
  WHERE t.Study_id=p.Study_id  
  GROUP BY t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
   p.strPackage_nm, p.Package_id  
  ORDER BY 1,3,5  
*/  
SELECT t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
  p.strPackage_nm, p.Package_id, MAX(p.intVersion) intVersion, p.strPackageFriendly_nm, p.bitActive
 FROM #ClientList t LEFT OUTER JOIN Package P  
  ON t.Study_id=p.Study_id  
  GROUP BY t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
   p.strPackage_nm, p.Package_id, p.strPackageFriendly_nm, p.bitActive
  ORDER BY 1,3,5  
  
ELSE  
  
/*  
SELECT strClient_nm, Client_id, strStudy_nm, Study_id  
 FROM #ClientList  
  ORDER BY 1,3  
*/  
SELECT t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
  p.strPackage_nm, p.Package_id, MAX(p.intVersion) intVersion, p.strPackageFriendly_nm, p.bitActive
 FROM #ClientList t, Package P  
  WHERE t.Study_id=p.Study_id  
  GROUP BY t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id,   
   p.strPackage_nm, p.Package_id, p.strPackageFriendly_nm, p.bitActive
  ORDER BY 1,3,5  
  
DROP TABLE #ClientList  
  
  


