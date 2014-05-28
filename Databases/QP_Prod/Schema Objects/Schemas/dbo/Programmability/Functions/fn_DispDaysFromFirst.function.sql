﻿CREATE FUNCTION dbo.fn_DispDaysFromFirst (@SentMail_id INT, @datLogged DATETIME, @Disposition_id INT)      
RETURNS INT      
AS      
BEGIN      

declare @result int

--DRM 04/16/2012  Changed calculation to look at datreturned instead of datlogged.  
SET @result = (select top 1 DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),qf.datreturned)
FROM questionform qf (NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)      
WHERE schm.SentMail_id =@sentmail_id  
AND schm.SamplePop_id=schm2.SamplePop_id      
AND schm2.SentMail_id=sm.SentMail_id      
AND qf.samplepop_id = schm.samplepop_id 
and qf.datreturned is not null 
GROUP BY qf.datreturned)

if @result is null      
SET @result = (select Distinct DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),dl.datLogged)      
FROM DispositionLog dl(NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)      
WHERE dl.SentMail_id=@SentMail_id      
AND dl.datLogged=@datLogged      
AND dl.SentMail_id=schm.SentMail_id      
AND schm.SamplePop_id=schm2.SamplePop_id      
AND schm2.SentMail_id=sm.SentMail_id      
AND dl.Disposition_id=@Disposition_id      
GROUP BY dl.datLogged)

return @result      

END


