CREATE PROCEDURE [dbo].[SP_RemoveErrors_PrintQueue]         
AS   
  
declare @checkdate int, @errorcount_previous int, @PCLComplete_previous int, @PCLNeeded_previous int,  
@errorcount_current int, @PCLComplete_current int, @PCLNeeded_current int  
  
set @errorcount_previous = (select COUNT(*) as [COUNT] from FormGenError (nolock))  
set @PCLComplete_previous = (select count(distinct sentmail_id) PCLComplete from pcloutput2 (nolock))  
set @PCLNeeded_previous = (select count(*) as PCLNeeded from pclneeded (nolock))  
  
set @checkdate = (select COUNT(*) from PCLCounts_log  
where left(datCaptured,11) in (SELECT left((cast(getdate() as varchar)),11)))  
  
--select @checkdate  
--Check to see if this is the first time the proc is running today.  
if @checkdate = 0   
 begin  
  insert into PCLCounts_log values(GETDATE(),@PCLComplete_previous,@PCLNeeded_previous,@errorcount_previous)  
  print 'One record inserted today for the first time'  
 end  
  
--select * from PCLCounts_log  
  
if @checkdate >= 1   
print @checkdate  
begin  
  
--set @errorcount_current = (select @errorcount_previous from PCLCounts_log)  
--set @PCLComplete_current = (select @PCLComplete_previous from PCLCounts_log)  
--set @PCLNeeded_current = (select @PCLNeeded_previous from PCLCounts_log)  
  
  
set @errorcount_current = (@errorcount_previous)  
set @PCLComplete_current = (@PCLComplete_previous)  
set @PCLNeeded_current = (@PCLNeeded_previous)  
  
  
  if @PCLComplete_current <> @PCLComplete_previous  
   begin return end  
  
  if @PCLComplete_current = @PCLComplete_previous   
   begin   
     
    if @errorcount_current > 0 begin   
           delete formgenerror where FGErrorType_id not in (36,37)
           print 'Delete ForgenError'   
           insert into PCLreset_log values(GETDATE(),'Deleted ' + cast(@errorcount_current as varchar) + ' Errors')  
           end  
    if @PCLNeeded_current > 0 begin   
           update pclneeded set bitdone = 0 where bitdone = 1  
           print 'Update Bitdone'   
           insert into PCLreset_log values(GETDATE(),'Reset ' + cast(@PCLNeeded_current as varchar) + ' Surveys')  
          end  
   end  
   
  if @errorcount_current = 0 and @PCLNeeded_current = 0  
   begin  
    Print 'Shall run PrinttoMoveQueue script'   
    -- Include PrinttoMovequeue script  
 --******************************************************************************  
  
    DELETE a     
    from pcloutput2 a  
    join npSentMailing b  
    on a.sentmail_ID = b.sentmail_ID  
  
  
    WHILE (SELECT COUNT(*) FROM pcloutput2) > 0  
    BEGIN  
     begin tran  
       
     select distinct top 500 sentmail_id  
     into #sm  
     from pcloutput2  
  
     if @@error <> 0  
       begin   
       rollback tran   
       return  
       end  
       
     INSERT INTO NPSentMailing (SENTMAIL_ID,SCHEDULEDMAILING_ID,DATGENERATED,DATPRINTED,DATMAILED,METHODOLOGY_ID,PAPERCONFIG_ID,  
        STRLITHOCODE,STRPOSTALBUNDLE,INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDeleted,datBundled,intReprinted,datReprinted)  
     SELECT SM.SENTMAIL_ID,SM.SCHEDULEDMAILING_ID,DATGENERATED,'1/1/4000','1/1/4000',SM.METHODOLOGY_ID,PAPERCONFIG_ID,  
        STRLITHOCODE,STRPOSTALBUNDLE,INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDeleted,datBundled,intReprinted,datReprinted  
     FROM SentMailing SM, #sm t  
     WHERE SM.sentmail_id = t.sentmail_id  
       
     if @@error <> 0  
       begin   
       rollback tran   
       return  
       end  
       
     insert into qp_queue.dbo.pcloutput  
     select p.*   
     from pcloutput2 p, #sm t  
     where t.sentmail_id = p.sentmail_id  
       
     if @@error <> 0  
       begin   
       rollback tran   
       return  
       end  
       
     delete p  
     from pcloutput2 p, #sm t  
     where t.sentmail_id = p.sentmail_id  
       
     if @@error <> 0  
       begin   
       rollback tran   
       return  
       end  
       
     commit tran  
       
     drop table #sm  
    END  
  
 --********************************************************************************************************************  
    insert into PCLreset_log values(GETDATE(),'Moved ' + cast(@PCLComplete_current as varchar)+ ' Surveys to Print Queue')  
    End  
end


