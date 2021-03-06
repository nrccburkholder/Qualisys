USE [QP_DataLoad]
GO
/****** Object:  StoredProcedure [dbo].[GetOCSHHFileStatus]    Script Date: 4/12/2016 12:38:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Dana Petersen>
-- Create date: <08/10/2012>
-- Description:	<Proc called by OCSHHSampleFileStatus proc on NRC10. Used to create OCS HH File Status SSRS report>
-- 02/12/2015 TS Added  strFileLocation and strFile_nm from DataFile table
--				 Added Error Messages for Abandoned Files
-- =============================================

ALTER PROCEDURE [dbo].[GetOCSHHFileStatus] 
	@LoadBegDate varchar(10),
	@LoadEndDate varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

--EXEC dbo.GetOCSHHFileStatus '10/1/2014','1/13/2015'

--DECLARE	@LoadBegDate varchar(10), @LoadEndDate varchar(10)
--SET @LoadBegDate = '10/1/2014'
--SET @LoadEndDate = '1/13/2015'


-- Get all the info for the files loaded in the specified month	
select 
 SUBSTRING(uf.origfile_nm,charindex('OCS',uf.origfile_nm)+3,6) as CCN,     
 uf.OrigFile_Nm,      
 us.UploadState_Nm as UploadState,      
 ufs.datOccurred as UploadDatOccurred,      
 df.DataFile_id,      
 df.intRecords,      
 df.intLoaded,      
 df.datEnd,      
 dfs.datOccurred as DataFileDatOccurred,
 df.datMaxDate as MaxEncDate,      
 df.DataSet_id,      
 dfss.State_desc  as DatafileState, 
 df.survey_id
 ,df.strFileLocation
 ,df.strFile_nm
 ,dfs.StateParameter
into #tmpFiles   
from       
 dbo.UploadFile uf with(nolock)      
 INNER JOIN dbo.UploadFileState ufs with(nolock) 
	on uf.UploadFile_id = ufs.UploadFile_id
 inner join dbo.UploadStates us with (nolock) 
	on ufs.UploadState_id = us.uploadstate_id     
 LEFT JOIN dbo.UploadFilesToDataFiles ufdf with(nolock) 
	on uf.UploadFile_id=ufdf.UploadFile_id      
 LEFT JOIN dbo.DataFile df with(nolock) 
	on ufdf.DataFile_id = df.DataFile_id      
 LEFT JOIN dbo.DataFileState dfs with(nolock) 
	on df.DataFile_id = dfs.DataFile_id
 left join dbo.DataFileStates dfss with (nolock) 
	on dfs.State_ID = dfss.State_ID  
 where ufs.datOccurred between @LoadBegDate and @LoadEndDate
 and CHARINDEX('UPDATE',uf.OrigFile_Nm) = 0
 
 
 /* ABANDONED FILE ERRORS -- Get Abandoned file Error Messages.  There may be multiple Error messages  TS*/
 ; 
 WITH tmpError AS
 ( 
	SELECT tf.DataFile_ID, RTRIM(dflm.ErrorMessage) AS ErrorMessage
	FROM #tmpfiles tf
	INNER JOIN dbo.DataFileLoadMsg dflm
		ON tf.DataFile_id = dflm.DataFile_ID
	WHERE 	tf.DatafileState = 'Abandoned' 
)	
SELECT DataFile_ID, 
	STUFF((SELECT ', ' + CAST(a.ErrorMessage AS varchar(max))
	FROM tmpError a
	WHERE a.DataFile_ID = b.DataFile_ID
	FOR XML PATH('')),1,1,'') AS ErrorMessageList
INTO #tmpErrors	
FROM tmpError B
GROUP BY DataFile_ID


--Some files may be loaded more than once, so get the most recently loaded file
select CCN, MAX(UploadDatOccurred) as LastUploadDate
into #tmpLastFiles
from #tmpFiles
group by CCN

/*
select tf.* from #tmpLastFiles tlf, #tmpFiles tf
where tlf.CCN = tf.CCN
and tlf.LastUploadDate = tf.UploadDatOccurred
order by tf.ccn
*/

/* FINAL DATASET - rewrote to include join to tmpErrors TS */
SELECT tf.*, ter.ErrorMessageList
FROM #tmpLastFiles tlf
INNER JOIN #tmpFiles tf
	ON tlf.CCN = tf.CCN
	AND tlf.LastUploadDate = tf.UploadDatOccurred
LEFT OUTER JOIN #tmpErrors ter	
	ON tf.DataFile_ID = ter.DataFile_ID
ORDER BY tf.ccn	

drop table #tmpFiles
drop table #tmpLastFiles
drop table #tmpErrors


END
