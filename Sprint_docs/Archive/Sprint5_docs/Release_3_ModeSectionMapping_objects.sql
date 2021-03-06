USE [QP_Prod]

/****** Object:  Table [dbo].[ModeSectionMapping]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ModeSectionMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Survey_Id] [int] NULL,
	[MailingStepMethod_Id] [int] NULL,
	[MailingStepMethod_nm] [varchar](42) NULL,
	[Section_Id] [int] NULL,
	[SectionLabel] [varchar](60) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO



GO
/****** Object:  StoredProcedure [dbo].[QCL_InsertModeSectionMapping]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_InsertModeSectionMapping]
@SurveyId INT,
@MailingStepMethodId INT,
@MailingStepMethod_nm varchar(50),
@QuestionSectionId INT,
@QuestionSectionLabel varchar(60)

AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


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

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF



GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectAvailableMailingMethodsBySurveyID]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectAvailableMailingMethodsBySurveyID]
@SurveyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select distinct msm.MailingStepMethod_id, msm.MailingStepMethod_nm
from mailingstepmethod msm
INNER JOIN mailingstep ms ON msm.mailingstepmethod_id = ms.mailingstepmethod_id
INNER JOIN mailingmethodology mm ON ms.methodology_id = mm.methodology_id
where mm.bitactivemethodology = 1
and (ms.bitsendsurvey = 1 or msm.isnonmailgeneration = 1)
and mm.survey_id =  @SurveyId


GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectModeSectionMapping]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectModeSectionMapping]
@Id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select Id, Survey_ID, MailingStepMethod_Id, MailingStepMethod_nm, Section_ID, SectionLabel
from ModeSectionMapping
WHERE Id = @Id


GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectModeSectionMappingsBySurveyId]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectModeSectionMappingsBySurveyId]
@SurveyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select Id, Survey_ID, MailingStepMethod_Id, MailingStepMethod_nm, Section_ID, SectionLabel
from ModeSectionMapping
WHERE Survey_Id = @SurveyId
GO
/****** Object:  StoredProcedure [dbo].[QCL_UpdateModeSectionMapping]    Script Date: 8/13/2014 2:24:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_UpdateModeSectionMapping]
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



GO

/****** Object:  StoredProcedure [dbo].[QCL_DeleteModeSectionMapping]    Script Date: 8/13/2014 2:43:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_DeleteModeSectionMapping]
@Id INT


AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DELETE [dbo].[ModeSectionMapping]
WHERE ID = @Id


GO

