/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S44 US12 CG-CAHPS Completeness 
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 3 - Create new function CGCAHPSCompleteness, based on MNCMCompleteness on QP_Prod, use mappings table, add new subtypes, to check for complete/partial/incomplete using measures & ATAs

	CREATE FUNCTION [dbo].[CGCAHPSCompleteness]

	Tim Butler

*/


USE [QP_Prod]
GO


IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  [name] = 'fn_CGCAHPSCompleteness'
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' )
				  )
		DROP FUNCTION [dbo].[fn_CGCAHPSCompleteness]

GO


