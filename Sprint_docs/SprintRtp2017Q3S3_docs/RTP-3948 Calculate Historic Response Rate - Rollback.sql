/*
	RTP-3948 Calculate Historic Response Rate

	Dave Gilsdorf

	CREATE PROCEDURE [dbo].[QCL_CreateCAHPSRollingYear]

*/
use qp_prod
go
IF OBJECT_ID('[dbo].[QCL_CreateCAHPSRollingYear]') IS NOT NULL
	DROP PROCEDURE [dbo].[QCL_CreateCAHPSRollingYear]
GO
