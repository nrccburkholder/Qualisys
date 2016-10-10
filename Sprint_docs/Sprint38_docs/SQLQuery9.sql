--/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP 1000 [DataFile_id]
--      ,[intVersion]
--      ,[FileType_id]
--      ,[Package_id]
--      ,[strFileLocation]
--      ,[strOrigFile_nm]
--      ,[strFile_nm]
--      ,[intFileSize]
--      ,[intRecords]
--      ,[datReceived]
--      ,[datBegin]
--      ,[datEnd]
--      ,[intLoaded]
--      ,[datMinDate]
--      ,[datMaxDate]
--      ,[datDeleted]
--      ,[DataSet_id]
--      ,[AssocDataFiles]
--      ,[IsDRGUpdate]
--      ,[IsLoadToLive]
--  FROM [QP_Load].[dbo].[DataFile]
--  order by datafile_id desc

DECLARE @File_id int

SET @File_id = 1981

DECLARE @Study_id INT, @Package_id INT, @Version INT  

SELECT @Package_id=p.Package_id, @Version=p.intVersion, @Study_id=Study_id      
FROM DataFile df, Package_View p      
WHERE df.DataFile_id=@File_id 
AND df.Package_id=p.Package_id      
AND df.intversion=p.intVersion      

DECLARE @survyetype_id int



select @survyetype_id = surveytype_id
from Qualisys.QP_Prod.dbo.SurveyType
where surveytype_dsc = 'Hospice CAHPS'

select * from Qualisys.QP_Prod.dbo.Survey_Def where study_id = @Study_id and surveytype_id = @survyetype_id

if exists(select 1 from Qualisys.QP_Prod.dbo.Survey_Def where study_id = @Study_id and surveytype_id = @survyetype_id)
begin

	DECLARE @count int
	DECLARE @dynSQL nvarchar(1000)

	set @dynSQL = 'SELECT @cnt = count(*)
	FROM (select DatePart(yyyy, ServiceDate) yr, DatePart(mm, ServiceDate) mo
	from [dbo].[DataFile_' + CAST(@File_id as varchar) + ']
		where servicedate is not null
		group by DatePart(yyyy, ServiceDate), DatePart(mm, ServiceDate)) t'

	exec sp_executesql @dynSQL, N' @cnt int OUTPUT', @count OUTPUT
 
	if @count > 1
	begin
		Insert into LD_LoadWarnings (dataFile_ID, Package_ID, intVersion,Study_ID, WarningMsg) select @File_id, @Package_ID, @Version, @Study_ID, 'This dataset constains more than one(1) month.'
	end 
	else print 'count = ' + cast(@count as varchar)

end