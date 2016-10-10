/*

	S58 ATL-772 Add DRG Update Rollback to QLoader Rollbacks Tab

	As the Manager of Client Operations, I want to be able to initiate a DRG update rollback from the rollbacks tab in QLoader, so that I can roll back bad updates.

	Tim Butler

	CREATE PROCEDURE [dbo].[LD_SelectDRGUpdates]


*/

USE QP_Load

GO

IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].[LD_SelectDRGUpdates]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[LD_SelectDRGUpdates]
GO


-- =============================================
-- Author:		Tim Butler
-- Create date: 2016.09.15
-- Description:	Returns a list of DRG updates that are not yet past the CMS submission date.
-- Calls LD_SelectDRGUpdates from Qualisys.QP_Prod
-- =============================================
CREATE    PROCEDURE [dbo].[LD_SelectDRGUpdates] @Study_ID int
AS

SET NOCOUNT ON
EXEC QUALISYS.QP_PROD.DBO.LD_SelectDRGUpdates @Study_ID

GO


IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].[LD_UpdateDRG_Rollback]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[LD_UpdateDRG_Rollback]
GO


CREATE PROCEDURE [dbo].[LD_UpdateDRG_Rollback] @Study_ID int, @DataFile_id int        
AS        
        
SET NOCOUNT ON
EXEC QUALISYS.QP_PROD.DBO.LD_UpdateDRG_Rollback @study_id, @datafile_id

GO