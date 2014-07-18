USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_InsertModeSectionMapping]    Script Date: 7/14/2014 8:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_InsertModeSectionMapping]
@SurveyId INT,
@MailingStepMethodId INT,
@MailingStepMethod_nm varchar(50),
@QuestionSectionId INT,
@QuestionSectionLabel varchar(60)

AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

begin trans

INSERT INTO [dbo].[ModeSectionMapping]
           ([Survey_Id]
           ,[MailingStepMethod_Id]
           ,[MailingStepMethod_nm]
           ,[Section_Id]
           ,[SectionLabel])
     VALUES
           (@SurveyId
           ,@MailingStepMethodId
           ,@MailingStepMethod_nm
           ,@QuestionSectionId
           ,@QuestionSectionLabel)

commit trans
