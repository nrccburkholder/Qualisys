/****** Object:  StoredProcedure [dbo].[copy_Script]    Script Date: 08/09/2006 13:33:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_Script]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[copy_Script]
GO
/****** Object:  StoredProcedure [dbo].[copy_Script]    Script Date: 08/09/2006 13:33:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_Script]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE procedure copy_Script(
   @fromScriptID int                  -- the script id to copy from
 )
as
/* This procedure copies scripts,  and their underlying script screens and script screen categories.
Eventually,  this will also copy pertinent triggers between screens,  but that isn''t fully ironed out yet,
so right now,  it does not.


Written by Hib Engler Jan 7, 2002
*/

begin

declare @toScriptID int
declare  @newScriptScreenID int

/* make the copy of the script */
insert into scripts (
  surveyID,
  scriptTypeID,
  name,
  description,
  completenessLevel,
  followSkips,
  calcCompleteness,
  DefaultScript)
select 
  surveyID,
  scriptTypeID,
  ''Copy of '' + name + '' ('' + convert(varchar(10), scriptid) +'')'', -- just to make the name slightly different from the original.
  description,
  CompletenessLevel,
  followSkips,
  calcCompleteness,
  DefaultScript
from scripts
where scriptID = @fromScriptID

/* now determine the script id.  Note:  this is not a safe way to do this!!! */
set @toScriptID = @@IDENTITY

/* Make a temporary mapping table for script screens.
This step wouldn''t be necessary if there was a natural unique key for scriptscreens,  but alas,  there is not a natural unique key.
Sp we map the new ids to the old ids so that we can properly translate the scriptScreenCategories later on down the road.
*/
create table #ScriptScreenMapping (
  fromScriptScreenID int primary key,    -- the script screen id from the original
  toScriptScreenID int unique)           -- the proposed script screen id to the copy

create table #triggermapping (
  fromTriggerID int primary key,
  toTriggerID int)

create table #criteriamapping (
  fromcriteriaID int primary key,
  tocriteriaID int)

declare getScriptScreens cursor for  -- look at all original script screens
  select scriptScreenID
  from scriptScreens
  where ScriptID=@fromScriptID

declare @scriptScreenID int


open getScriptScreens
fetch getScriptScreens into @scriptScreenID
while @@fetch_Status = 0
  begin
  -- for each script screen,  insert a scriptscreen, and a mapping row.

  insert into ScriptScreens(
    ScriptID,
    SurveyQuestionID,
    Title,
    Text,
    CalculationTypeID,
    ItemOrder)
  select 
    @ToScriptID,         -- the new script, instead of the old one
    SurveyQuestionID,
    Title,
    Text,
    CalculationTypeID,
    ItemOrder
  from scriptscreens s
  where s.ScriptScreenID = @ScriptScreenID

  set @NewScriptScreenID = @@IDENTITY -- aha! thats what we just did

  insert into #scriptScreenMapping values (@ScriptScreenID,@NewScriptScreenID) -- save the mapping for later

  fetch getScriptScreens into @scriptScreenID    -- get the next record
  end
close getScriptScreens
deallocate getScriptScreens


/* insert the categories that are pertinent*/
insert into scriptScreenCategories(
   ScriptScreenID,
   AnswerCategoryID,
   JumpToScriptScreenID,
   Text)
  select 
    m.ToScriptScreenID,   -- translated from old to new
    ssc.AnswerCategoryID,
    m2.ToScriptScreenID,  -- also translated,   IF THERE IS A TRANSLATION!
			  -- some records have 0 or -999 in this id number,  so we 
                          -- will not beable to map those in this select.
    ssc.Text
  from 
    ScriptScreens ss,
    ScriptScreenCategories ssc,
    #scriptScreenMapping m, -- mapping for ScriptScreenID
    #scriptScreenMapping m2 -- mappinf for JumpToScriptScreenID
  where ss.ScriptID = @fromScriptID
    and ss.ScriptScreenID = ssc.ScriptScreenID
    and ssc.ScriptScreenID = m.FromScriptScreenID
    and ssc.JumpToScriptScreenID = m2.FromScriptScreenID
 union all -- this union takes care of the rows where the jumptoScriptScreenID is not a "valid" mapped id
           -- such as 0 or -999.  In this case,  we leave the JumpToScriptScreenID as is.
  select 
     m.ToScriptScreenID,
     ssc.AnswerCategoryID,
     JumpToScriptScreenID,   -- no mapping in this select
     ssc.Text
  from 
    ScriptScreens ss,
    ScriptScreenCategories ssc,
    #scriptScreenMapping m
  where ss.ScriptID = @fromScriptID

    and ss.ScriptScreenID = ssc.ScriptScreenID
    and ssc.ScriptScreenID = m.FromScriptScreenID
    and not exists (select ''x'' -- checking to see that the jumptoScriptScreenID doesnt map
      from #scriptScreenMapping m2
      where ssc.JumpToScriptScreenID = m2.FromScriptScreenID)




/* we copy the criteria first -- incase the criteria was shared amongst many triggers in the script */
declare getCriteria cursor for
  select distinct t.criteriaid
  from scriptedTriggers st, triggers t
  where st.triggerID = t.triggerID
  and t.triggertypeid = 1 -- script screen transition
  and st.triggerIDvalue1=@fromScriptID  -- other types might also use the script screen in the future,  but not right now.
  and t.criteriaid is not null
  
declare @criteriaID int
declare @newCriteriaID int

open getCriteria
fetch getCriteria into @criteriaID
while @@fetch_Status = 0
  begin
  exec dbo.copy_criteria @criteriaID,@newCriteriaID output
  print ''criterion '' + convert(varchar(10),@criteriaID) + convert(varchar(10),@newCriteriaID)
  insert into #criteriaMapping (fromCriteriaID,toCriteriaID)
  values (@criteriaID,@newCriteriaID)

  fetch getCriteria into @criteriaID
  end
close getCriteria
deallocate getCriteria


/* blank out the name,  and make the triggers */
declare getTrigger cursor for
  select distinct t.triggerID
  from scriptedTriggers st, triggers t
  where st.triggerID = t.triggerID
  and t.triggertypeid = 1 -- script screen transition
  and st.triggerIDvalue1=@fromScriptID  -- other types might also use the script screen in the future,  but not right now.

declare @triggerID int
declare @newTriggerID int
open getTrigger
fetch getTrigger into @triggerID
while @@fetch_Status = 0
  begin

  insert into triggers(triggerTypeID,SurveyID,TriggerName,criteriaID,TheCode,PerodicyDate,PerodicyNextDate)
    select distinct t.triggerTypeID,SurveyID,null,toCriteriaID,theCode,PerodicyDate,PerodicyNextDate
    from triggers t
    left outer join #criteriaMapping m
    on t.criteriaID = m.fromCriteriaID
  where t.triggerID = @triggerID
  
  set @newTriggerID = @@identity

  insert into #triggerMapping(fromTriggerID,toTriggerID) 
  values (@triggerID,@newTriggerID)
  
  fetch getTrigger into @triggerID
  end
close getTrigger
deallocate getTrigger



/* now that we have duplicated triggers and criteria of triggers,  we can create the  scripted triggers */
insert into scriptedTriggers(triggerID,triggerIDValue1,triggerIDValue2,triggerIDValue3,triggerIDValue4)
select nt.toTriggerID,@toScriptID,ns.toScriptScreenID,triggerIDVAlue3,triggerIDValue4
from scriptedTriggers st
inner join triggers t
on st.triggerID = t.triggerID
and st.triggeridvalue1 = @fromScriptID
and t.triggerTypeID = 1   --has to be a scripted trigger -- otherwise these values might mean something else
left outer join #triggermapping nt
on nt.fromTriggerID = t.triggerID
left outer join #scriptscreenmapping ns
on st.triggerIDValue1 = ns.fromScriptScreenID


-- clean up
drop table #ScriptScreenMapping
drop table #triggermapping
drop table #criteriamapping

select @toScriptID
end


' 
END
GO
