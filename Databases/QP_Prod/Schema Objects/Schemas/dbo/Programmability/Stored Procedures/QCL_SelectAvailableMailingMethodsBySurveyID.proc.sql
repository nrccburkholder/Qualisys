USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectAvailableMailingMethodsBySurveyID]    Script Date: 7/14/2014 8:18:51 AM ******/
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

