USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionnaireTypes]    Script Date: 8/18/2014 8:58:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectQuestionnaireType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectQuestionnaireTypes]
GO
