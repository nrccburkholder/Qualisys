--Modified 6/24/2 BD Changed the procedure to only check the Loc tables since they are the tables populated by PCLGen.
CREATE PROCEDURE sp_pcl_cleanbatch_2
AS

 declare @nextbatch int
 set rowcount 1
 SELECT @nextbatch=batch_id
 FROM ##MyPCLNeeded
 set rowcount 0
 if @nextbatch IS NULL OR @nextbatch <= 0
  return
/* Remove PCLOutput that hasn't yet been printed for this SentMailing */
 BEGIN TRANSACTION
 DELETE dbo.PCLOutput
  FROM dbo.PCLOutput PO, ##MyPCLNeeded PN, dbo.SentMailing SM
  WHERE
    PN.SentMail_id=PO.SentMail_ID AND
    PO.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
/* DELETE qp_scan.dbo.BubbleLoc
 FROM qp_scan.dbo.BubbleLoc BL, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    BL.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 DELETE qp_scan.dbo.CommentLoc
 FROM qp_scan.dbo.CommentLoc CL, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    CL.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
*/
/*
 DELETE qp_scan.dbo.BubblePos
 FROM qp_scan.dbo.BubblePos BP, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    BP.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 DELETE qp_scan.dbo.BubbleItemPos
 FROM qp_scan.dbo.BubbleItemPos BIP, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    BIP.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 DELETE qp_scan.dbo.CommentPos
 FROM qp_scan.dbo.CommentPos CP, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    CP.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 DELETE qp_scan.dbo.CommentLinePos
 FROM qp_scan.dbo.CommentLinePos CLP, #MyPCLNeeded PN, dbo.SentMailing SM
 WHERE
    CLP.QuestionForm_id=PN.QuestionForm_id AND
    PN.SentMail_ID=SM.SentMail_id AND
    SM.datPrinted=null
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
*/
/* If there are still records in PCLOutput, etc. for patients */
/* in PCLNeeded, change their batch_ids to <0 so tat they'll be */
/* put into FormGenError log */
/* update dbo.pclneeded
 set batch_id = -12
 from dbo.PCLNeeded pn, qp_scan.dbo.commentlinepos clp
 where clp.questionform_id = pn.questionform_id
 and pn.batch_id = 266036
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 update dbo.pclneeded
 set batch_id = -11
 from dbo.PCLNeeded pn, qp_scan.dbo.commentpos cp
 where cp.questionform_id = pn.questionform_id
 and pn.batch_id = 266036
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 update dbo.pclneeded
 set batch_id = -10
 from dbo.PCLNeeded pn, qp_scan.dbo.bubbleitempos bip
 where bip.questionform_id = pn.questionform_id
 and pn.batch_id = 266036
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 update dbo.pclneeded
 set batch_id = -9
 from dbo.PCLNeeded pn, qp_scan.dbo.bubblepos bp
 where bp.questionform_id = pn.questionform_id
 and pn.batch_id = 266036
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
*/
/* update dbo.pclneeded
 set batch_id = -10
 from dbo.PCLNeeded pn, qp_scan.dbo.bubbleloc bl
 where bl.questionform_id = pn.questionform_id
 and pn.batch_id = @nextbatch
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
 update dbo.pclneeded
 set batch_id = -9
 from dbo.PCLNeeded pn, qp_scan.dbo.commentloc cl
 where cl.questionform_id = pn.questionform_id
 and pn.batch_id = @nextbatch
 if @@error <> 0
 begin
  ROLLBACK TRANSACTION
  return
 end
*/
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
 delete ##MYPCLNeeded
 from ##MYPCLNeeded mpn, dbo.PCLNeeded pn
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


