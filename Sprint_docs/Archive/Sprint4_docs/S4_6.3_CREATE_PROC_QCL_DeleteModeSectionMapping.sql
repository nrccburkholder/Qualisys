USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_InsertModeSectionMapping]    Script Date: 7/14/2014 8:18:51 AM ******/
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

