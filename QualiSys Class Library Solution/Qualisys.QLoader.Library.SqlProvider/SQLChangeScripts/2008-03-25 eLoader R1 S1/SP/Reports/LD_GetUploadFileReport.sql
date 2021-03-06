SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[LD_GetUploadFileReport]
		@pMinDate datetime,
		@pMaxDate datetime,
		@pSelections varchar(8000) = null
as

declare @mindate varchar(25)
declare @maxdate varchar(25)
declare @criteria varchar(8000)
declare @sql varchar(8000)  
declare @selections varchar(8000)

set @criteria = null
set @mindate=convert(varchar, @pMinDate)
set @maxdate=convert(varchar, dateadd(ms,-3,dateadd(dd,1,@pMaxDate)))

if @pSelections is not null
begin
	set @selections = replace(@pSelections, ' ', '')

	if left(@pSelections,1)='P'
	begin
		set @selections=replace(@selections,'P','')
		set @criteria='and j.employee_id in ('+@selections+')'
	end
	  
	if left(@pSelections,1)='C'
	begin
		set @selections=replace(@selections,'C','')
		set @criteria='and e.client_id in ('+@selections+')'
	end
end

if @criteria is null set @criteria = ''


set @sql = 'select	b.datOccurred,
		d.intTeamNumber,
		j.employee_id,
		j.stremployee_first_nm,
		j.stremployee_last_nm,
		e.client_id,
		e.strclient_nm,
		f.strstudy_nm,
		d.strpackage_nm,
		a.uploadfile_id,
		a.origfile_nm,
		a.file_nm,
		g.uploadaction_nm,
		h.uploadstate_nm,
		i.strmember_nm,
		a.usernotes
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
inner join uploadactions g
 on a.uploadaction_id = g.uploadaction_id
inner join uploadstates h
 on b.uploadstate_id = h.uploadstate_id
inner join nrcauth.nrcauth.dbo.member i
 on a.member_id = i.member_id
inner join qualisys.qp_prod.dbo.employee j
 on f.ademployee_id = j.employee_id 
where b.datOccurred between ''' + @mindate + ''' and ''' + @maxdate + ''' 
' + @criteria

exec (@sql)


