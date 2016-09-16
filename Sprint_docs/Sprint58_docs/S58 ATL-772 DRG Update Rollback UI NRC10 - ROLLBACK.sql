/*
	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S58 ATL-772 Add DRG Update Rollback to QLoader Rollbacks Tab

	As the Manager of Client Operations, I want to be able to initiate a DRG update rollback from the rollbacks tab in QLoader, so that I can roll back bad updates.

	Tim Butler

	DROP PROCEDURE [dbo].[LD_SelectDRGUpdates]


*/

USE QP_Prod

GO

if exists (select * from sys.procedures where name = 'LD_SelectDRGUpdates')
	drop procedure LD_SelectDRGUpdates

GO


if exists (select * from sys.procedures where name = 'LD_UpdateFileStateDRG')
	drop procedure LD_UpdateFileStateDRG

GO