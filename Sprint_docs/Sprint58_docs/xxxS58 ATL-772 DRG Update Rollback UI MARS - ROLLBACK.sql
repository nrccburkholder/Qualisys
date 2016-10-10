/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S58 ATL-772 Add DRG Update Rollback to QLoader Rollbacks Tab

	As the Manager of Client Operations, I want to be able to initiate a DRG update rollback from the rollbacks tab in QLoader, so that I can roll back bad updates.

	Tim Butler

	DROP PROCEDURE [dbo].[LD_SelectDRGUpdates]


*/

USE QP_Load

GO

IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].[LD_SelectDRGUpdates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[LD_SelectDRGUpdates]
GO
