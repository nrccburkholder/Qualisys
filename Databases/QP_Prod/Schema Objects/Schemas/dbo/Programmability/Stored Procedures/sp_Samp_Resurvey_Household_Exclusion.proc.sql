--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/****** Object:  Stored Procedure dbo.sp_Samp_Resurvey_Household_Exclusion    Script Date: 4/25/02 2:57:18 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_Resurvey_Household_Exclusion
Part of:  Sampling Tool
Purpose:  updates #Universe, setting Removed_Rule to 1 for anyone who is in the same household as someone who's had something
          mailed to them within @intResurveyEx_period days
Input:  
 
Output:  
Creation Date: 04/25/2002
Author(s): Dave Gilsdorf 
Revision: First build - 04/25/2002
***********************************************************************************************************************************/
CREATE PROCEDURE dbo.sp_Samp_Resurvey_Household_Exclusion 
	@Study_id int, 
	@intResurveyEx_Period int, 
	@strHouseholdField_CreateTable varchar(1000), 
	@strHouseholdField_Select varchar(1000),
	@strHouseholdField_Select_BV varchar(1000),
	@strHousehold_Join varchar(1000),
	@strHousehold_Type char(1),
	@intMinorExcept_Crit_id int
as

-- setting a constant that identify which rule excluded encounters from Universe
DECLARE @ResurveyRemoveFlag char(1)
SELECT @ResurveyRemoveFlag = '5'

create table #HH_lastmailing (datMailed datetime)
exec ('alter table #HH_lastmailing add '+@strHouseholdField_CreateTable)


-- list all households that have been mailed during the resurvey exclusion period

-- SCM.SentMail_id = NULL means that something has been scheduled to mail for a patient, but hasn't been generated yet.
-- "isnull(SCM.sentmail_id,@maxSentMail_id)" along with "isnull(SM.datMailed,getdate())" will make sure we act as if
-- it mailed today.  That is, it will stay in the list of households that have been mailed something recently.
declare @maxSentMail_id int, @SQL varchar(8000)
select @maxSentMail_id = max(SentMail_id) from sentmailing

If @strHousehold_Type = 'A' 
	set @SQL = ''
ELSE
	if @intMinorExcept_Crit_id <> -1
		select @SQL = 'bv.POPULATIONage<18 and not ('+strCriteriaBV+') and ' 
		from #CriteriaStmt 
		where criteriastmt_id = @intMinorExcept_Crit_id
	else
		set @SQL = 'bv.POPULATIONage<18 and '

set @SQL = 'insert into #HH_lastmailing (datMailed, '+@strHouseholdField_Select+')
select max(isnull(SM.datMailed,getdate())), '+@strHouseholdField_Select_BV+'
from s'+convert(varchar,@study_id)+'.big_view BV, samplepop SP, scheduledmailing SCM, sentmailing SM
where ' + @SQL + 'bv.PopulationPop_id = sp.pop_id
and SP.samplepop_id = SCM.samplepop_id
and isnull(SCM.sentmail_id,'+convert(varchar,@maxSentMail_id)+')=SM.sentmail_id
and datediff(day,isnull(SM.datMailed,getdate()),getdate()) <= ' + convert(varchar,@intResurveyEx_Period) + '
group by '+@strHouseholdField_Select_BV
exec (@SQL)

set @SQL = 'update U
set Removed_Rule = ' + @ResurveyRemoveFlag + '
from #Universe U, #HH Y, #HH_LastMailing X
where Removed_Rule = 0
and U.HH_id=Y.HH_id
and ' + @strHousehold_Join 
exec (@SQL)

drop table #HH_lastmailing


