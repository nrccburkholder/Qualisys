CREATE PROCEDURE SP_QUEUE_SetExpiration          
AS          
          
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
exec qp_prod.dbo.sp_getemailsubject 'FORMGEN: SP_QUEUE_SetExpiration failed',@country, @environment, 'Qualisys', @osubject=@vsubject output

DECLARE @rc INT, @rc2 INT          
          
BEGIN TRANSACTION          
          
--Remove the SentMail_ids that no longer exist.          
DELETE q          
FROM SetExpiration_Queue q LEFT OUTER JOIN SentMailing sm          
ON q.SentMail_id=sm.SentMail_id          
WHERE sm.SentMail_id IS NULL          
      
--MWB 6/24/08      
--Deleting all rows where the datmailed in sentmailing is null      
--this could happen if the mail date is set back to null via a Track-it ticket      
--and this table is not cleaned up.      
DELETE q          
FROM SetExpiration_Queue q, SentMailing sm          
where q.SentMail_id=sm.SentMail_id and sm.datmailed IS NULL          
      
      
--Determine when the expirefromstep mailingstep was mailed.            
-- datExpire is a calculated field in the SetExpiration_Queue table.          
UPDATE seq          
SET PreviousMailDate=datMailed          
FROM SetExpiration_Queue seq(NOLOCK), ScheduledMailing schm(NOLOCK), SentMailing sm(NOLOCK)          
WHERE seq.SamplePop_id=schm.SamplePop_id          
AND seq.ExpireFromStep=schm.MailingStep_id          
AND schm.SentMail_id=sm.SentMail_id          
        
SELECT @rc=@@ROWCOUNT          
          
--Set the expiration in sentmailing          
UPDATE sm          
SET sm.datExpire=seq.datExpire          
FROM SetExpiration_Queue seq, SentMailing sm          
WHERE seq.datExpire>'1/1/1900'          
AND seq.SentMail_id=sm.SentMail_id          
        
        
SELECT @rc2=@@ROWCOUNT          
          
IF @rc<>@rc2          
BEGIN          
-- EXEC MASTER.dbo.XP_SendMail @Recipients='dba@nationalresearch.com', @Subject='FORMGEN: SP_QUEUE_SetExpiration failed'        
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',    
@recipients='dba@nationalresearch.com',    
@subject=@vsubject,    
@body_format='Text',    
@importance='High'    
ROLLBACK TRANSACTION          
RETURN          
END          
          
--Delete the updated records from the queue table          
DELETE SetExpiration_Queue           
WHERE datExpire>'1/1/1900'          
          
SELECT @rc2=@@ROWCOUNT          
          
IF @rc<>@rc2          
BEGIN          
--EXEC MASTER.dbo.XP_SendMail @Recipients='dba@nationalresearch.com', @Subject='FORMGEN: SP_QUEUE_SetExpiration failed'        
     
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',    
@recipients='dba@nationalresearch.com',    
@subject=@vsubject,    
@body_format='Text',    
@importance='High'    
     
ROLLBACK TRANSACTION          
RETURN          
END          
          
--We commit if all of the counts match.          
COMMIT TRANSACTION     


--Expire any new seed mailing surveys.
--Look 2 days out to account for delays in setting print/mail dates.
--DRM  09/20/2011
update sm
set datexpire = cast(floor(cast(getdate()+2 as float)) as datetime)
from sentmailing sm inner join scheduledmailing schm
on sm.sentmail_id = schm.sentmail_id
inner join seedmailingsamplepop smp
on schm.samplepop_id = smp.samplepop_id
where (sm.datexpire is null
or sm.datexpire > cast(floor(cast(getdate()+2 as float)) as datetime))
and sm.datmailed is not null	--DRM  11/20/2011  Added check to make sure we're not expiring surveys that haven't mailed yet.


