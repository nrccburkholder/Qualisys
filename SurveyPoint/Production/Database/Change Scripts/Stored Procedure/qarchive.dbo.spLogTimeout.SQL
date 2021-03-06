/****** Object:  StoredProcedure [dbo].[spLogTimeout]    Script Date: 08/09/2006 12:57:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spLogTimeout]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spLogTimeout]
GO
/****** Object:  StoredProcedure [dbo].[spLogTimeout]    Script Date: 08/09/2006 12:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spLogTimeout]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE dbo.spLogTimeout
(
        @SessionID varchar(100)
)
AS
BEGIN
declare abc cursor for
   select userID FROM EventLog
   WHERE EventID =1001 
     AND EventParameters = @SessionID 
     AND EventDate >=
       (SELECT MAX(EventDate) 
        FROM EventLog
        WHERE EventID = 1000
        AND EventParameters = @SessionID)
   union all
   select userID FROM EventLog
   WHERE EventID =1002 
     AND EventParameters = @SessionID
     AND EventDate >=
       (SELECT MAX(EventDate) 
        FROM EventLog
        WHERE EventID = 1000
        AND EventParameters = @SessionID)

declare @userID int

set @userID = null;
/* fetch just 1 row from the cursor */
open abc;
fetch abc into @userID;
close abc;
deallocate abc;

if @userID is not null   -- we have found our user id from before
      INSERT INTO EventLog (EventDate, EventID, UserID, EventParameters)
        SELECT GETDATE(), 1002, @UserID, @SessionID 


END


' 
END
GO
GRANT EXECUTE ON [dbo].[spLogTimeout] TO [reporter]
GO
