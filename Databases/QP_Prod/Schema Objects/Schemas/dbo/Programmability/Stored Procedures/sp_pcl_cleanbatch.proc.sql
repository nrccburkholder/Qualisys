--Modified 6/24/2 BD Changed the procedure to only check the Loc tables since they are the tables populated by PCLGen.
--Modified 1/22/04 DG Change so this process is skipped for test prints
CREATE PROCEDURE sp_pcl_cleanbatch
AS

 declare @nextbatch int, @bitTestPrints bit
 set rowcount 1
 SELECT @nextbatch=batch_id, @bitTestPrints=bitTestPrints 
 FROM #MyPCLNeeded
 set rowcount 0
 if @nextbatch IS NULL OR @nextbatch <= 0 or @bitTestPrints=1
  return
/* Remove PCLOutput that hasn't yet been printed for this SentMailing */
 BEGIN TRANSACTION
 DELETE dbo.PCLOutput
  FROM dbo.PCLOutput PO, #MyPCLNeeded PN, dbo.SentMailing SM
  WHERE
    PN.SentMail_id=PO.SentMail_ID AND
    PO.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end

 update dbo.pclneeded
 set batch_id = -8
 from dbo.PCLNeeded pn, dbo.PCLOutput po
 where po.sentmail_id = pn.sentmail_id
 and pn.batch_id = @nextbatch
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 delete #MYPCLNeeded
 from #MYPCLNeeded mpn, dbo.PCLNeeded pn
 where mpn.samplepop_id = pn.samplepop_id 
 and mpn.survey_id = pn.survey_id
 and mpn.selcover_id = pn.selcover_id
 and mpn.language = pn.language
 and mpn.sentmail_id = pn.sentmail_id
 and mpn.questionform_id = pn.questionform_id
 and pn.batch_id < 0
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
/* Add bad PCLGen records to FormGenError */
 declare @ErrorTime datetime
 select @ErrorTime=getdate()
 insert into dbo.FormGenError (
  ScheduledMailing_id, datGenerated, FGErrorType_id
 ) select
  sm.ScheduledMailing_id,
  @ErrorTime,
  abs(pn.batch_id)
 from dbo.PCLNeeded pn, dbo.ScheduledMailing sm
 where pn.sentmail_id = sm.sentmail_id
 and pn.batch_id < 0
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 exec dbo.sp_PCL_CleanUpErrors @ErrorTime
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 delete from dbo.PCLNeeded where batch_id < 0
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 COMMIT TRANSACTION


