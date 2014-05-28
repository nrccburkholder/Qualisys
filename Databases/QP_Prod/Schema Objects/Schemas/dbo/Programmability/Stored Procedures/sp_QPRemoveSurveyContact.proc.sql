/****** Object:  Stored Procedure dbo.sp_QPRemoveSurveyContact    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPRemoveSurveyContact    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPRemoveSurveyContact    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QPRemoveSurveyContact
@mSurveyContactID int
AS
DELETE Survey_Contact
WHERE SurveyContact_ID = @mSurveyContactID


