/****** Object:  Stored Procedure dbo.sp_SendThankYou    Script Date: 6/9/99 4:36:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_SendThankYou    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_SendThankYou    Script Date: 12/7/98 2:34:55 PM ******/
/* Written by: Greg Bogard (Cap Gemini)
** Date:  Sept 23, 1998
**
*/
CREATE PROCEDURE sp_SendThankYou
@pstrLithoCode varchar(10)
AS
SELECT MS.*
FROM MailingStep MS,
SentMailing SM
WHERE SM.strLithoCode = @pstrLithoCode
AND SM.Methodology_Id = MS.Methodology_Id
AND MS.bitThankYouItem = 1
if @@error <> 0
 begin
  raiserror(14043, 16, -1, 'Failed to select thankYouItems-scanimport module')
  return(1)
 end
return(0)


