/****** Object:  StoredProcedure [dbo].[spGetListOfDependantTriggersToRun]    Script Date: 08/09/2006 12:57:55 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetListOfDependantTriggersToRun]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spGetListOfDependantTriggersToRun]
GO
/****** Object:  StoredProcedure [dbo].[spGetListOfDependantTriggersToRun]    Script Date: 08/09/2006 12:57:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetListOfDependantTriggersToRun]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.spGetListOfDependantTriggersToRun
/* Created by Hib Engler on 12/29/2002
This procedure will return a list of dependant triggers to run.
This is meant to be called just after a trigger has run successfully.  It 
looks at trigger dependencies for triggers that depend onthis trigger.
Then it looks to see if any of THOSE candidates have other dependencies that need to be met
Then it thise candidates have dependencies that need to be met,  it checks to see if those dependencies have been done
successfully.

Then it returns the list
*/
(
     @triggerID int,            -- Identifier of the trigger being run
     @value1 int,              -- first parameterized value to identify the context of the trigger being run.
                                       -- this value will be differnet based on the type of trigger.  For instance,
                                       -- A trigger of type ResponseInterview will probably have the responseID in value1
                                       -- Whereas a trigger of type manual will probably have null passed in.
                                       -- the triggers are defaulted to -7777 if they are null - so we don''t have to worry about
                                       -- null checks.
     @value2 int,              -- Second parameterized value,  if there is any
     @value3 int,              -- Third parameterized value, if there is any
     @value4 int               -- fourth parameterized value,  if there is any
)
 AS
begin
-- set the values to 7777 if they are null.
if @Value1 is null 
  set @Value1=-7777
if @Value2 is null 
  set @Value2=-7777
if @Value3 is null 
  set @Value3=-7777
if @Value4 is null 
  set @Value4=-7777


select nextToRun.TriggerID /* candidate triggers that depend on this trigger */
from triggerDependencies nextToRun
where DependsOnTriggerID = @TriggerID
and not exists (   /* and we dont find any prerequisite dependencies that are unfulfilled for this trigger */
  select ''x'' 
  from TriggerDependencies prerequisites
  where prerequisites.triggerID = nextToRun.triggerID
    and preRequisites.DependsonTriggerID != @TriggerID /* no need to look at the current trigger, as we can assume that it completed */
  and not exists ( /* if a valid trigger log exists,  than this prerequisite is satisfied,  so 
                    we don''t need to return it. */
    select ''x'' from TriggerLog /* look for a matching trigger log with a successful status */
    where TriggerLog.triggerID = preRequisites.DependsOnTriggerID
      and TriggerIDValue1 = @value1
      and TriggerIDValue2 = @value2
      and TriggerIDValue3 = @value3
      and TriggerIDValue4 = @value4
      and StatusFlag != 0
    )
  )



end


' 
END
GO
GRANT EXECUTE ON [dbo].[spGetListOfDependantTriggersToRun] TO [reporter]
GO
