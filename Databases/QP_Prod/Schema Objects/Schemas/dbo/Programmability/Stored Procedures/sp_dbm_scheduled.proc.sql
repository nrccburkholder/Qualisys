create procedure sp_dbm_scheduled as 
declare @strsql varchar(2000), @cnt int, @curdate varchar(10)

set @curdate = convert(varchar(10),getdate(),120)

insert into capacity (dat_dt) select @curdate

set @strsql = 'declare @cnt int set @cnt = (select count(*) from scheduledmailing schm, mailingstep ms, survey_def sd ' +
	' where datgenerate <= "' + @curdate + '"' +
	' and schm.mailingstep_id = ms.mailingstep_id ' +
	' and ms.survey_id = sd.survey_id ' +
	' and schm.sentmail_id is null ' +
	' and bitformgenrelease = 1) ' +
	' update capacity set scheduled = @cnt where dat_dt = "' + @curdate + '"'

exec(@strsql)


