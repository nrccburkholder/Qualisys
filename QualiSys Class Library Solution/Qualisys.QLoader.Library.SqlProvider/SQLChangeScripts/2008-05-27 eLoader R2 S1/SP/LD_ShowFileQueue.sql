USE [QP_Load]
GO
/****** Object:  StoredProcedure [dbo].[LD_ShowFileQueue]    Script Date: 03/27/2008 16:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[LD_ShowFileQueue] 
	@strLogin_nm 	VARCHAR(42)
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


SELECT t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id, 
  p.strPackage_nm, p.Package_id, MAX(p.intVersion) intVersion,   
  CONVERT(VARCHAR,datReceived)+' ('+strFile_nm+')' strFile_nm,   
  df.DataFile_id, df.AssocDataFiles, strOrigFile_nm FileName, strPackageFriendly_nm, bitActive
 FROM #ClientList t, Package P, DataFile df, DataFileState dfs
  WHERE t.Study_id=p.Study_id
  AND p.Package_id = df.Package_id
  AND df.DataFile_id = dfs.DataFile_id    
  AND dfs.State_id > 5    
  AND dfs.State_id < 9    
  GROUP BY t.strClient_nm, t.Client_id, t.strStudy_nm, t.Study_id, 
   p.strPackage_nm, p.Package_id,   
   CONVERT(VARCHAR,datReceived)+' ('+strFile_nm+')',   
   df.DataFile_id, df.AssocDataFiles, strOrigFile_nm, strPackageFriendly_nm, bitActive
  ORDER BY 1,3,5,8

DROP TABLE #ClientList


