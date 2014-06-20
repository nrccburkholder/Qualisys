﻿CREATE PROCEDURE WebPref_ContactRequest @Litho VARCHAR(20), @Disposition_id INT, @Comment VARCHAR(256)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

--Log it
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)
SELECT @Litho,@Disposition_id,GETDATE(),'Contact: '+@Comment

SELECT 1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

