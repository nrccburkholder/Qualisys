/****** Object:  StoredProcedure [dbo].[spLogTrigger]    Script Date: 08/09/2006 12:57:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spLogTrigger]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spLogTrigger]
GO
/****** Object:  StoredProcedure [dbo].[spLogTrigger]    Script Date: 08/09/2006 12:57:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spLogTrigger]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.spLogTrigger
/* Created by Hib Engler on 12/29/2002
This procedure will insert/update an entry into the TriggerLog table.  This table is used to figure out dependencies.
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
     @value4 int,               -- fourth parameterized value,  if there is any
     @successFlag int,      -- 1 if the trigger succeeded,  0 otherwise.
     @parameterText varchar(2000)    -- optional parameter text
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


-- See if the applicable trigger log exists
declare @TriggerLogID int
set @TriggerLogID= null
select @TriggerLogID  = TriggerLogID 
from TriggerLog
where TriggerID = @TriggerID
and TriggerIDValue1 = @Value1
and TriggerIDValue2 = @Value2
and TriggerIDValue3 = @Value3
and TriggerIDValue4 = @Value4

if @TriggerLogID is not null 
  begin
  update triggerLog
  set StatusFlag= @successFlag,
     ParameterValues = @parameterText,
     CompleteDate=getDate()
  where TriggerLogID=@TriggerLogId
end
else
  begin

  insert into triggerLog
  (TriggerID,
   TriggerIDValue1,
   TriggerIDValue2,
   TriggerIDValue3,
   TriggerIDValue4,
   CompleteDate,
   StatusFlag,
   ParameterValues)
values (@triggerID,@value1,@value2,@value3,@value4,
getdate(),@successFlag,@parameterText)

end

end


' 
END
GO
GRANT EXECUTE ON [dbo].[spLogTrigger] TO [reporter]
GO
