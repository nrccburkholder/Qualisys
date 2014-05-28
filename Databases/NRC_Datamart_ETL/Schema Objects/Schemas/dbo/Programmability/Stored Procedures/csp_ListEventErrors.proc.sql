-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[csp_ListEventErrors]
	@ExtractFileID int

AS
BEGIN
	SET NOCOUNT ON

   Select 'ExtractHistoryError',*
    From dbo.ExtractHistoryError with (NOLOCK)
    Where ExtractFileID = @ExtractFileID

  Select 'BackgroundTempError',*
   From dbo.BackgroundTempError with (NOLOCK)
   Where ExtractFileID = @ExtractFileID
  
   Select 'CommentTextTempError',*
    From dbo.CommentTextTempError with (NOLOCK)
    Where ExtractFileID = @ExtractFileID

  
END


