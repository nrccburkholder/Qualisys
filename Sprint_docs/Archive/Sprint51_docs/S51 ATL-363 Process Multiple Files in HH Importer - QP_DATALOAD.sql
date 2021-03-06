
/*
S51 ATL-363 Process Multiple Files in HH Importer

Tim Butler


CREATE FUNCTION [dbo].[Split]
CREATE PROCEDURE [dbo].[LD_CheckForDuplicateCCNInSampleMonth] 
INSERT DataFileState - DuplicateCCNInSampleMonth
CREATE PROCEDURE [dbo].[LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates] 
CREATE PROCEDURE [dbo].[LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates]   
CREATE PROCEDURE LD_DisableAutoSamplingByStudyID
CREATE PROCEDURE LD_UnscheduledSamplesetByDataFileID


*/



USE [QP_DataLoad]
GO

IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[Split]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
	DROP FUNCTION [dbo].[Split]

GO

CREATE FUNCTION [dbo].[Split]
/* This function is used to split up multi-value parameters */
(
@ItemList NVARCHAR(4000),
@delimiter CHAR(1)
)
RETURNS @IDTable TABLE (Item NVARCHAR(50) collate database_default )
AS
BEGIN
	DECLARE @tempItemList NVARCHAR(4000)
	SET @tempItemList = @ItemList

	DECLARE @i INT
	DECLARE @Item NVARCHAR(4000)

	SET @tempItemList = REPLACE (@tempItemList, @delimiter + ' ', @delimiter)
	SET @i = CHARINDEX(@delimiter, @tempItemList)

	WHILE (LEN(@tempItemList) > 0)
	BEGIN
	IF @i = 0
	SET @Item = @tempItemList
	ELSE
	SET @Item = LEFT(@tempItemList, @i - 1)

	INSERT INTO @IDTable(Item) VALUES(@Item)

	IF @i = 0
	SET @tempItemList = ''
	ELSE
	SET @tempItemList = RIGHT(@tempItemList, LEN(@tempItemList) - @i)

	SET @i = CHARINDEX(@delimiter, @tempItemList)
	END
	RETURN
END

GO


USE [QP_DataLoad]
GO

if exists (select * from sys.procedures where name = 'LD_CheckForDuplicateCCNInSampleMonth')
	drop procedure LD_CheckForDuplicateCCNInSampleMonth

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LD_CheckForDuplicateCCNInSampleMonth]    
    @File_id INT, 
	@indebug int = 0     
AS    
    

if @indebug = 1 print 'Start QP_DataLoading LD_CheckForDuplicateCCNInSampleMonth' 

DECLARE @currentMonth int 
DECLARE @currentYear int 
DECLARE @CCN varchar(10)  

  SELECT @CCN = substring(uf.OrigFile_Nm,patindex('%hhcahps%',uf.OrigFile_Nm)+8,6), @currentMonth = DATEPART(mm,df.datReceived), @currentYear = DATEPART(yy,df.datReceived)
  FROM [dbo].[UploadFilesToDataFiles] ufdf
  inner join [dbo].[UploadFile] uf on uf.UploadFile_id = ufdf.UploadFile_id
  inner join [dbo].[DataFile] df on df.DataFile_id = ufdf.DataFile_id
  where df.DataFile_id = @File_id

SELECT df.DataFile_id,  substring(uf.OrigFile_Nm,patindex('%hhcahps%',uf.OrigFile_Nm)+8,6) CCN
INTO #temp
  FROM [dbo].[UploadFilesToDataFiles] ufdf
  inner join [dbo].[UploadFile] uf on uf.UploadFile_id = ufdf.UploadFile_id
  inner join [dbo].[DataFile] df on df.DataFile_id = ufdf.DataFile_id
  inner join [dbo].[DataFileState] dfs on dfs.DataFile_id = df.DataFile_id
  inner join DataFileStates dfss on dfs.State_ID = dfss.State_ID
  left join Qualisys.qp_prod.dbo.data_set ds on df.DataSet_id = ds.dataset_id
  where DATEPART(mm,df.datReceived) = @currentMonth and DATEPART(yy,df.datReceived) = @currentYear
  AND ((dfss.State_desc in ('Applied') and ds.recordcount > 0) or (dfss.State_desc in ('AwaitingValidation','Validating','AwaitingApply','AwaitingFirstApproval')))
  and df.DataFile_id <> @file_id
  order by df.DataFile_id 

if @indebug = 1 print 'End QP_DataLoading LD_CheckForDuplicateCCNInSampleMonth' 

if exists (select 1 from #temp where CCN = @CCN)
begin

	DECLARE @datafile_id int
	select @datafile_id = DataFile_id from #temp where CCN = @CCN
	insert into DataFileLoadMsg (DataFile_ID, ErrorLevel_ID, ErrorMessage)  
	select @File_id, 3, 'A file for CCN ' + @CCN + ' has already been loaded for sample month ' + cast(@currentMonth as varchar) + '/' + cast(@currentYear as varchar) + ' (DataFileID: ' + cast(@datafile_id as varchar) + ')'

	select @datafile_id
end
else
	select 0

DROP TABLE #temp
	

GO



/*
 INSERT DataFileState - DuplicateCCNInSampleMonth
*/


USE [QP_DataLoad]
GO

if not exists (SELECT [State_ID]
      ,[State_desc]
		FROM [QP_DataLoad].[dbo].[DataFileStates]
		WHERE State_desc = 'DuplicateCCNInSampleMonth')
BEGIN

	DECLARE @State_ID int

	SET IDENTITY_INSERT[dbo].[DataFileStates] ON; 

	SELECT @State_ID = max(State_ID) FROM [dbo].[DataFileStates]

	SET @State_ID = @State_ID + 1

	INSERT INTO [dbo].[DataFileStates]
			   ([State_iD], [State_desc])
		 VALUES
			   (@State_ID, 'DuplicateCCNInSampleMonth')

	SET IDENTITY_INSERT[dbo].[DataFileStates] OFF;

END

GO


USE [QP_DataLoad]
GO



if exists (select * from sys.procedures where name = 'LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates')
	drop procedure LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates

GO

CREATE PROCEDURE [dbo].[LD_SelectClientsStudiesAndSurveysByUserAndDataFileStates]    
    @UserName VARCHAR(42),    
    @ShowAllClients BIT = 0,  
    @DataFileStates VARCHAR(1000)  
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
--Need a temp table to hold the ids the user has rights to    
CREATE TABLE #EmpStudy (    
    Client_id INT,    
    Study_id INT,    
    strStudy_nm VARCHAR(10),    
    strStudy_dsc VARCHAR(255),  
    ADEmployee_id int,  
    datCreate_dt datetime,  
    bitCleanAddr bit,  
    bitProperCase bit,  
    Active bit  
)    
  
--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,  
         datCreate_dt, bitCleanAddr, bitProperCase, Active)    
SELECT DISTINCT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,  
    datCreate_dt, bitCleanAddr, bitProperCase, Active  
FROM dbo.css_PervasiveViewer_Tree  
WHERE strNTLogin_nm = @UserName    
  
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    
  
--First recordset.  List of clients they have rights to.    
IF @ShowAllClients = 1    
BEGIN    
 SELECT DISTINCT c.Client_id, c.strClient_nm, c.ClientActive Active, c.ClientGroup_ID    
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Client_id = c.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))
 GROUP BY c.Client_id, c.strClient_nm, c.ClientActive, c.ClientGroup_ID  
 ORDER BY c.strClient_nm  
END    
ELSE    
BEGIN  
 SELECT DISTINCT c.Client_id, c.strClient_nm, c.ClientActive Active, c.ClientGroup_ID    
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Client_id = c.Client_id   
  AND d.Client_id = c.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))
 GROUP BY c.Client_id, c.strClient_nm, c.ClientActive, c.ClientGroup_ID  
 ORDER BY c.strClient_nm  
END  
  
--Second recordset.  List of studies  
IF @ShowAllClients = 1    
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.strStudy_nm, c.StudyActive Active       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Study_ID = c.Study_ID  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,',')) 
 ORDER BY c.STRSTUDY_NM  
END    
ELSE    
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.strStudy_nm, c.StudyActive Active       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_ID = c.Study_ID  
  AND d.Study_ID = c.Study_ID  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))
 ORDER BY c.STRSTUDY_NM  
END  
  
--Third recordset.  List of surveys  
IF @ShowAllClients = 1  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, c.strSurvey_nm, c.SurveyActive Active       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END  
ELSE  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, c.strSurvey_nm, c.SurveyActive Active       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_id = c.STUDY_ID  
  AND d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END  
  
--Fourth recordset.  List of datafiles    
IF @ShowAllClients = 1  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, d.DataFile_id, d.strFile_nm       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))
 ORDER BY c.STRSTUDY_NM    
END  
ELSE  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, d.DataFile_id, d.strFile_nm       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_id = c.STUDY_ID  
  AND d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM    
END  
  
--Cleanup temp table    
DROP TABLE #EmpStudy    


GO



USE [QP_DataLoad]
GO

if exists (select * from sys.procedures where name = 'LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates')
	drop procedure LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates

GO

CREATE PROCEDURE [dbo].[LD_SelectClientGroupsClientsStudysAndSurveysByUserAndDataFileStates]    
    @UserName VARCHAR(42),    
    @ShowAllClients BIT = 0,  
    @DataFileStates VARCHAR(1000)  
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
--Need a temp table to hold the ids the user has rights to    
CREATE TABLE #EmpStudy (    
    Client_id INT,    
    Study_id INT,    
    strStudy_nm VARCHAR(10),    
    strStudy_dsc VARCHAR(255),  
    ADEmployee_id int,  
    datCreate_dt datetime,  
    bitCleanAddr bit,  
    bitProperCase bit,  
    Active bit  
)  
  
--Need a temp table to hold the client groups  
CREATE TABLE #ClientGroups (  
    ClientGroup_id INT,  
    ClientGroup_nm VARCHAR(50),  
    Active BIT  
)  
  
--Populate the Client Group temp table  
INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, Active)  
VALUES (-1, 'Unassigned', 1)  
  
INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, Active)  
SELECT DISTINCT ClientGroup_id, ClientGroup_nm, ClientGroupActive  
FROM dbo.cgcss_view  
ORDER BY ClientGroup_nm  
  
--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,  
         datCreate_dt, bitCleanAddr, bitProperCase, Active)    
SELECT DISTINCT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,  
    datCreate_dt, bitCleanAddr, bitProperCase, Active  
FROM dbo.css_PervasiveViewer_Tree  
WHERE strNTLogin_nm = @UserName    
  
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    
  
--First recordset.  List of client groups they have rights to or all client groups  
IF @ShowAllClients = 1  
BEGIN  
    SELECT DISTINCT cg.ClientGroup_id, cg.ClientGroup_nm, cg.Active  
    FROM #ClientGroups cg, dbo.cgcss_view cl, dbo.DataFile d, dbo.DataFileState s  
 WHERE  ISNULL(cl.ClientGroup_ID, -1) = cg.ClientGroup_id  
  AND d.Client_id = cl.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,',')) 
END  
ELSE  
BEGIN  
    SELECT DISTINCT cg.ClientGroup_id, cg.ClientGroup_nm, cg.Active  
    FROM #EmpStudy es, dbo.cgcss_view cl, #ClientGroups cg, dbo.DataFile d, dbo.DataFileState s  
    WHERE es.Client_id = cl.CLIENT_ID  
  AND ISNULL(cl.ClientGroup_ID, -1) = cg.ClientGroup_id  
  AND d.Client_id = cl.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))
    GROUP BY cg.ClientGroup_id, cg.ClientGroup_nm, cg.Active  
END  
  
--First recordset.  List of clients they have rights to.    
IF @ShowAllClients = 1    
BEGIN    
 SELECT DISTINCT c.Client_id, c.strClient_nm, c.ClientActive Active, c.ClientGroup_ID    
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Client_id = c.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 GROUP BY c.Client_id, c.strClient_nm, c.ClientActive, c.ClientGroup_ID  
 ORDER BY c.strClient_nm  
END    
ELSE    
BEGIN  
 SELECT DISTINCT c.Client_id, c.strClient_nm, c.ClientActive Active, c.ClientGroup_ID    
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Client_id = c.Client_id   
  AND d.Client_id = c.Client_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 GROUP BY c.Client_id, c.strClient_nm, c.ClientActive, c.ClientGroup_ID  
 ORDER BY c.strClient_nm  
END  
  
--Second recordset.  List of studies  
IF @ShowAllClients = 1    
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.strStudy_nm, c.StudyActive Active       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Study_ID = c.Study_ID  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END    
ELSE    
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.strStudy_nm, c.StudyActive Active       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_ID = c.Study_ID  
  AND d.Study_ID = c.Study_ID  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END  
  
--Third recordset.  List of surveys  
IF @ShowAllClients = 1  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, c.strSurvey_nm, c.SurveyActive Active       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END  
ELSE  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, c.strSurvey_nm, c.SurveyActive Active       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_id = c.STUDY_ID  
  AND d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM  
END  
  
--Fourth recordset.  List of datafiles    
IF @ShowAllClients = 1  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, d.DataFile_id, d.strFile_nm       
 FROM dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM    
END  
ELSE  
BEGIN  
 SELECT DISTINCT c.Client_id, c.Study_id, c.STRSTUDY_NM, c.Survey_id, d.DataFile_id, d.strFile_nm       
 FROM #EmpStudy t, dbo.cgcss_view c, dbo.DataFile d, dbo.DataFileState s  
 WHERE t.Study_id = c.STUDY_ID  
  AND d.Survey_id = c.Survey_id  
  AND d.DataFile_id = s.DataFile_id  
  AND s.State_ID in (SELECT Item FROM dbo.Split (@DataFileStates,','))  
 ORDER BY c.STRSTUDY_NM    
END  
  
--Cleanup temp table    
DROP TABLE #EmpStudy    
DROP TABLE #ClientGroups    


GO



USE [QP_DataLoad]
GO


if exists (select * from sys.procedures where name = 'LD_DisableAutoSamplingByStudyID')
	drop procedure LD_DisableAutoSamplingByStudyID

GO

CREATE PROCEDURE LD_DisableAutoSamplingByStudyID
	@study_id int
AS
BEGIN

	UPDATE s
		SET s.bitAutoSample = 0
	FROM Qualisys.QP_PROD.dbo.Study s 
	WHERE s.Study_ID = @study_id


END
GO




USE [QP_DataLoad]
GO


if exists (select * from sys.procedures where name = 'LD_UnscheduledSamplesetByDataFileID')
	drop procedure LD_UnscheduledSamplesetByDataFileID

GO

CREATE PROCEDURE LD_UnscheduledSamplesetByDataFileID
	@datafile_id int
AS
BEGIN


DECLARE @SampleSet_Id int


SELECT @SampleSet_Id = sds.sampleset_id
  FROM [QP_DataLoad].[dbo].[DataFile] df
  join Qualisys.qp_prod.dbo.data_set ds on df.DataSet_id = ds.dataset_id 
  join Qualisys.qp_prod.dbo.SampleDataSet sds on sds.DataSet_id = ds.DataSet_id
  where df.DataFile_id = @datafile_id

-- once we have the sampleset_id we can easily unschedule the generation

BEGIN TRY
	exec Qualisys.qp_prod.[dbo].[QCL_Samp_UnscheduleSampleSetGeneration] @SampleSet_Id
END TRY
BEGIN CATCH
	
END CATCH

END
GO


