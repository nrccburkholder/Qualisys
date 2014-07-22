USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_UpdateModeSectionMapping]    Script Date: 7/22/2014 12:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_UpdateModeSectionMapping]
@Id INT,
@MailingStepMethodId INT,
@MailingStepMethod_nm varchar(50),
@QuestionSectionId INT,
@QuestionSectionLabel varchar(60)

AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


UPDATE [dbo].[ModeSectionMapping]
           SET [MailingStepMethod_Id] = @MailingStepMethodId
           ,[MailingStepMethod_nm] = @MailingStepMethod_nm
           ,[Section_Id] = @QuestionSectionId
           ,[SectionLabel] = @QuestionSectionLabel
WHERE ID = @Id

