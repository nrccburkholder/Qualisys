USE [QP_Prod]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FG_CAHPSPreProcessing]
AS
	exec [dbo].[CheckForBlankBreakoffs]
	exec [dbo].[CheckForCAHPSIncompletes]