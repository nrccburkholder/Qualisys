-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the barcode lines
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetBarCodeLines] 
    @SentMailID int 
AS
--added by MH 8/28/2009 in an attempt to find the cause of missing lithos
insert into MH_PCLLOG (SentMailID, DT) values (@SentMailID, GetDate())

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intPA, strBarCodeA, intPB, strBarCodeB, 
       intPC, strBarCodeC, intPD, strBarCodeD 
FROM si_Barcode_view 
WHERE SentMail_Id = @SentMailID 
ORDER BY intPA 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


