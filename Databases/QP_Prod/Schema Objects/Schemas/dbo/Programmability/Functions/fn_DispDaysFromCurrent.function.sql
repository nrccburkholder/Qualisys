CREATE FUNCTION dbo.fn_DispDaysFromCurrent (@SentMail_id INT, @datLogged DATETIME, @Disposition_id INT)  
RETURNS INT  
AS  
BEGIN  
  
RETURN (SELECT Distinct DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)),datLogged)  
FROM DispositionLog dl(NOLOCK), SentMailing sm(NOLOCK)  
WHERE dl.SentMail_id=@SentMail_id  
AND dl.datLogged=@datLogged  
AND dl.SentMail_id=sm.SentMail_id  
AND dl.Disposition_id=@Disposition_id)  
  
END


