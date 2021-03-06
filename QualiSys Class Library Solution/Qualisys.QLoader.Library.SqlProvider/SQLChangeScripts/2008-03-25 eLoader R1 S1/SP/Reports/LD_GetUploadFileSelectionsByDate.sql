SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LD_GetUploadFileSelectionsByDate]
		@pMinDate datetime,
		@pMaxDate datetime,
		@pListType int
as

declare @mindate varchar(25)
declare @maxdate varchar(25)
declare @select varchar(250)
declare @sql varchar(8000)  


set @mindate=convert(varchar, @pMinDate)
set @maxdate=convert(varchar, dateadd(ms,-3,dateadd(dd,1,@pMaxDate)))

if @pListType = 0
	set @select = 'select distinct rtrim(j.stremployee_first_nm) + '' '' + rtrim(j.stremployee_last_nm) [Name],
		''P'' + cast(j.employee_id as varchar) [Name_id] '
else if @pListType = 1
	set @select = 'select distinct rtrim(e.strclient_nm) [Name],
		''C'' + cast(e.client_id as varchar) [Name_id] '

set @sql = @select + '
from uploadfile a inner join uploadfilestate b
 on a.uploadfile_id = b.uploadfile_id
inner join uploadfilepackage c
 on a.uploadfile_id = c.uploadfile_id
inner join package d
 on c.package_id = d.package_id
left join qualisys.qp_prod.dbo.client e
 on d.client_id = e.client_id
left join qualisys.qp_prod.dbo.study f
 on d.study_id = f.study_id
inner join qualisys.qp_prod.dbo.employee j
 on f.ademployee_id = j.employee_id 
where b.datOccurred between ''' + @mindate + ''' and ''' + @maxdate + ''''

exec (@sql)
