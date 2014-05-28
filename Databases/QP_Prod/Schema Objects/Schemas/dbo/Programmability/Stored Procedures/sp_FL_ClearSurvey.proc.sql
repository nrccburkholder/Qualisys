/****** Object:  Stored Procedure dbo.sp_FL_ClearSurvey    Script Date: 6/9/99 4:36:35 PM ******/
/****** Object:  Stored Procedure dbo.sp_FL_ClearSurvey    Script Date: 3/12/99 4:16:08 PM ******/
/**********************************************************
 Stored procedure used by Form Layout to delete a survey
 prior to resaving it.  - DS - 03/03/1999
**********************************************************/
CREATE PROCEDURE sp_FL_ClearSurvey @Survey_id NUMERIC AS
BEGIN
   BEGIN TRAN
      DELETE FROM Sel_Scls WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_Qstns WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_Skip WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_Logo WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_TextBox WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_PCL WHERE Survey_ID = @Survey_id 
      DELETE FROM Sel_Cover WHERE Survey_ID = @Survey_id 
      DELETE FROM SurveyLanguage WHERE Survey_ID = @Survey_id 
   COMMIT
END


