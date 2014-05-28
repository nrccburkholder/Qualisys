/****** Object:  Stored Procedure dbo.sp_QPAddSurveyContact    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddSurveyContact    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddSurveyContact    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QPAddSurveyContact 
@mSurveyID int,
@mContactID int,
@mContactType int
AS
INSERT Survey_Contact(Survey_ID, Contact_ID, ContactType_ID)
VALUES (@mSurveyID,@mContactID,@mContactType)


