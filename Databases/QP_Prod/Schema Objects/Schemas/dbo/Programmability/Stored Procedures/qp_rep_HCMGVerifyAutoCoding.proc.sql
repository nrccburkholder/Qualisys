/*    
//////////////////////////////////////////////////////////////////////    
// Copyright c National Research Corporation    
//    
// Routine Name:   qp_rep_HCMGVerifyAutoCoding
//    
//   Created By:   Hui Holay
//         Date:   	05-12-2006
//    
//  Description:   
//    
// Parameters:    
//   Name		Type		Description
//   --------------------------------------------------------------------------------------
//   @HCMGMarket	Varchar(255)	Market description
//   @BeginDate		Date
//   @EndDate			Date
// Revisions:    
// Date		By	Description
//
//////////////////////////////////////////////////////////////////////    
*/    
CREATE Procedure [dbo].[qp_rep_HCMGVerifyAutoCoding]
	@HCMGMarket VARCHAR(255),
	@BeginDate DATETIME,
	@EndDate DATETIME
AS

DECLARE @Market VARCHAR(4)

SELECT @Market = Market_id FROM HCMG.HCMG_Dev.dbo.Market 
WHERE @HCMGMarket = Market_dsc
--SET @Market = SUBSTRING(@Market,CHARINDEX('(', @Market) +1, LEN(@Market)-CHARINDEX('(', @Market)-1)

EXEC HCMG.HCMG_Dev.dbo.HCMG_VerifyAutoCoding @Market, @BeginDate, @EndDate


