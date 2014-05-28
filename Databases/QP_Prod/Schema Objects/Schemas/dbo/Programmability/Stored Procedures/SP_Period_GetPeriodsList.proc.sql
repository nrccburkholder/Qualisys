/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_GetPeriodsList
*
*	Description:
		This will return a list of available periods for a given survey.
*
*	Parameters:
		@survey_id
			This is the survey ID.
*
*	Return:
		Recordset contain the period properties information
*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE         PROCEDURE dbo.SP_Period_GetPeriodsList
	@survey_id int
AS
set transaction isolation level read uncommitted

create table #periods (periodDef_id int, ActivePeriod int default 0)

--Get a list of all periods for this survey
insert into #periods (periodDef_id)
select periodDef_id
from perioddef
WHERE survey_id=@survey_id

--Get a list of all periods that have not completed sampling
select distinct pd.PeriodDef_id
into #temp
from perioddef p, perioddates pd
where p.perioddef_id=pd.perioddef_id and
		survey_id=@survey_id and
	  	datsamplecreate_dt is null

--Find the active Period.  It is either a period that hasn't completed sampling
--or a period that hasn't started but has the most recent first scheduled date 
--If no unfinished periods exist, set active period to the period with the most
--recently completed sample 

IF EXISTS (select top 1 *
			from #temp)
BEGIN
	
	DECLARE @UnfinishedPeriod int
	
	SELECT @UnfinishedPeriod=pd.perioddef_id
	FROM perioddates pd, #temp t
	where pd.perioddef_id=t.perioddef_id and
		  	pd.samplenumber=1 and
			pd.datsamplecreate_dt is not null
	
	IF @UnfinishedPeriod is not null
	BEGIN
		--There is a period that is partially finished, so set it to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id = @UnfinishedPeriod
	END
	ELSE
	BEGIN
		--There is no period that is partially finished, so set the unstarted period
		--with the earliest scheduled sample date to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id =
			(SELECT top 1 pd.perioddef_id
			 FROM perioddates pd, #temp t
			 where pd.perioddef_id=t.perioddef_id and
				  	pd.samplenumber=1
			 ORDER BY datscheduledsample_dt)
	END
END
ELSE
BEGIN
	--No unfinished periods exist, so we will set the active to be the most recently
	--finished
	UPDATE #periods
	SET ActivePeriod=1
	WHERE perioddef_id =
		(SELECT top 1 p.perioddef_id
		 FROM perioddates pd, perioddef p
		 where p.survey_id=@survey_id and
				pd.perioddef_id=p.perioddef_id
		 GROUP BY p.perioddef_id
		 ORDER BY Max(datsamplecreate_dt) desc)
END

select *
from #periods

drop table #temp
drop table #periods


