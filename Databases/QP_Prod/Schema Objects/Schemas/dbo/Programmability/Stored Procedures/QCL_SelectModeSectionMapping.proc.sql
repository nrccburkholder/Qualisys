USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectModeSectionMapping]    Script Date: 7/14/2014 8:18:51 AM ******/
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