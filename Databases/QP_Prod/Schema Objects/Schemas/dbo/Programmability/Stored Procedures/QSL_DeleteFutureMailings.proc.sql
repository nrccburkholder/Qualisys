/************************************************************************************************
 * Modified by: Dave Gilsdorf - 2/5/14 -- if the disposition being logged is Bad Address, don't delete future phone steps.
 *              if the disposition is Bad Phone, don't delete future mail steps. This sprang from an ACO CAHPS requirement
 *
 ************************************************************************************************/
CREATE PROCEDURE [dbo].[QSL_DeleteFutureMailings]
  @SentMailID      INT,
  @SamplePopID     INT,
  @DispositionID   INT,
  @DispositionDate DATETIME,
  @ReceiptTypeID   INT,
  @UserName        VARCHAR(42)
AS
  SET NOCOUNT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  --Delete any ungenerated steps for this samplepop_id    
 -- if @dispositionID=5 [bad address] don't delete phone steps
 -- if @dispositionID in (14,16) [bad phone] don't delete mail steps
  DELETE schm
  from ScheduledMailing schm
  inner join mailingStep ms on schm.mailingstep_id=ms.mailingstep_id
  inner join mailingstepmethod msm on ms.mailingstepmethod_id=msm.mailingstepmethod_id
  WHERE schm.SamplePop_id=@SamplePopID    
  AND schm.SentMail_id IS NULL    
  and  (
          (msm.mailingstepmethod_nm<>'Phone' or @dispositionid<>5) 
       and (msm.mailingstepmethod_nm<>'Mail' or @dispositionid not in (14,16))
        )

  --Insert the disposition
  EXEC dbo.QCL_LogDisposition
    @SentMailID
    ,@SamplePopID
    ,@DispositionID
    ,@ReceiptTypeID
    ,@UserName
    ,@DispositionDate

  --Update the undeliverable date
  IF @DispositionID IN (5, 14, 16) --Lee Kohrs 2013-08-07 added this line per HCAHPS2012 TR#4
	UPDATE dbo.SentMailing
	SET    datUndeliverable = @DispositionDate
	WHERE  SentMail_id = @SentMailID

  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
  SET NOCOUNT OFF


