/*
	RTP-3949 Create CalculateOasHhResponseRate - Rollback

	Lanny Boswell

	CREATE PROCEDURE [dbo].[CalculateOasHhResponseRate]

*/
use qp_prod
go

IF OBJECT_ID('[dbo].[CalculateOasHhResponseRate]') IS NOT NULL
	DROP PROCEDURE [dbo].[CalculateOasHhResponseRate]
GO
