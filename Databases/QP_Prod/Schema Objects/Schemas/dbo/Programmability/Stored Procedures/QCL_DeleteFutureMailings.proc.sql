/************************************************************************************************
 *
 * Business Purpose: This procedure is used to support the Qualisys Class Library.  It deletes
 *                   future mailings for the given litho.
 * Date Created:  10/11/2005
 *
 * Created by:  Brian Dohmen
 * Modified by: Steve Spicka - 8/22/06 -- Call  QCL_LogDisposition write to disposition table
 * Modified by: Dave Gilsdorf - 2/5/14 -- if the disposition being logged is Bad Address, don't delete future phone steps.
 *              if the disposition is Bad Phone, don't delete future mail steps. This sprang from an ACO CAHPS requirement
 *
 ************************************************************************************************/
CREATE PROCEDURE QCL_DeleteFutureMailings   
 @Litho VARCHAR(20),   
 @DispositionID INT,  
 @ReceiptTypeID INT,  
 @UserName VARCHAR(42)    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
DECLARE @SentMailID INT, @SamplePopID INT
    
--Need to get the samplepop_id from the litho.  This is used to find ungenerated steps.
SELECT @SentMailID=sm.SentMail_id, @SamplePopID=SamplePop_id
FROM SentMailing sm
inner join ScheduledMailing schm on sm.SentMail_id=schm.SentMail_id    
WHERE sm.strLithoCode=@Litho    

BEGIN TRANSACTION    

--delete any ungenerated steps for the samplepop_id
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

IF @@ERROR<>0    
BEGIN    
	ROLLBACK TRANSACTION    
	SELECT -1    
	RETURN    
END    
    
--Log it    
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)    
SELECT @Litho,@DispositionID,GETDATE(),'Deleted Future Mailings'    
    
IF @@ERROR<>0    
BEGIN    
	ROLLBACK TRANSACTION    
	SELECT -1    
	RETURN    
END    
  
--Need to log the disposition for reporting purposes  
EXEC dbo.QCL_LogDisposition @SentMailID, @SamplepopID, @DispositionID, @ReceiptTypeID, @UserName
  
IF @@ERROR<>0        
BEGIN        
	ROLLBACK TRAN        
	SELECT -1        
	RETURN        
END        
    
COMMIT TRANSACTION    
SELECT 1    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


