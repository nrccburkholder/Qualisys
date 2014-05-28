/****** Object:  Stored Procedure dbo.sp_Queue_PCLGenStatus    Script Date: 12/9/1999 2:44:50 PM ******/
/* This procedure returns 1 if there's been an addition to PCLGenLog in the last five minutes */
/* Created by:  Dave Gilsdorf 12/9/1999 */
CREATE PROCEDURE sp_Queue_PCLGenStatus 
 @IsRunning bit OUTPUT
AS
 DECLARE @PCLGenLastLog datetime
 /* I used the following SELECT (instead of SELECT @PCLGenLastLog=MAX(datLogged) FROM PCLGenLog)
    because there's an index on PCLGenLog_id but not one on datLogged, and I think it's faster.
    ?????   */
 SELECT @PCLGenLastLog = datLogged 
   FROM PCLGenLog 
   WHERE PCLGenLog_id = (SELECT MAX(PCLGenLog_id) FROM PCLGenLog)
 IF datediff(minute,@PCLGenLastLog,getdate()) < 5
  SELECT @IsRunning = 1
 ELSE
  SELECT @IsRunning = 0


