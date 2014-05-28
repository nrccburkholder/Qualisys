/****** Object:  Stored Procedure dbo.sp_FG_ShowLastDaysBatches    Script Date: 6/9/99 4:36:34 PM ******/
/****** Object:  Stored Procedure dbo.sp_FG_ShowLastDaysBatches    Script Date: 3/12/99 4:16:08 PM ******/
/****************************************************************************************
****** Returns the list of formgen batches processed in the last @days days       *******
*****************************************************************************************
****** RC - 03/10/1999                                                            *******
****************************************************************************************/
CREATE PROCEDURE sp_FG_ShowLastDaysBatches @Days INTEGER AS
 SELECT 'Batch Dates' = datGenerated, '# Mailing Items' = count(*)
  FROM SentMailing 
  WHERE DATEDIFF(day, datGenerated, GetDate()) < @Days
  GROUP BY datGenerated
  COMPUTE SUM(COUNT(*))


