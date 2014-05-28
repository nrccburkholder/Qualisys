/****** Object:  Stored Procedure dbo.sp_Samp_ApplyDQRule    Script Date: 9/28/99 2:57:11 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_ApplyDQRule
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_ApplyDQRule
 @intBusinessRule_id int,
 @vcBigView_Join varchar(8000),
 @vcDQRule_Where varchar(8000),
 @intStudy_id int
AS
 DECLARE @vcSQL varchar(8000)
 DECLARE @DQRuleRemoveRule tinyint
 SET @DQRuleRemoveRule = 4
 SET @vcSQL = 'UPDATE #SampleUnit_Universe' +
    ' SET DQ_Bus_Rule = ' + CONVERT(varchar, @intBusinessRule_id) + ', ' +
     ' Removed_Rule = ' + CONVERT(varchar, @DQRuleRemoveRule) +
    ' FROM #SampleUnit_Universe X, S' + CONVERT(varchar, @intStudy_id) + '.Big_View BV' +
    ' WHERE ' + @vcBigView_Join +
     ' AND ' + @vcDQRule_Where
 EXECUTE (@vcSQL)


