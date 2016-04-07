/*
S46 US16 Delete Groups & Sites.sql

As the Compliance PM, I would like to be able to delete CG-CAHPS groups & sites via the interface, 
so that we can remove incorrect entries

Limited by NRCAuth permission

Chris Burkholder

Task 2 - Hook up delete button, include checks if group/site assigned to facility
*/

Use [QP_Prod]
go

begin tran

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_PracticeSiteDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_PracticeSiteDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_PracticeSiteDelete]
GO

/****** Object:  StoredProcedure [dbo].[QCL_PracticeSiteDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QCL_PracticeSiteDelete]
	@PracticeSite_id int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	  FROM [dbo].[PracticeSite]
	  where (PracticeSite_ID = @PracticeSite_id)

END

GO

/****** Object:  StoredProcedure [dbo].[QCL_SiteGroupDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_SiteGroupDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_SiteGroupDelete]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SiteGroupDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QCL_SiteGroupDelete]
	@SiteGroup_id int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	  FROM [dbo].[SiteGroup]
	  where (SiteGroup_ID = @SiteGroup_id)

END

GO


/****** Object:  StoredProcedure [dbo].[QCL_SiteAllowDelete]    Script Date: 4/6/2016 10:20:33 AM ******/
if exists (select * from sys.procedures where name = 'QCL_SiteAllowDelete' and schema_id = SCHEMA_ID('dbo'))
	DROP PROCEDURE [dbo].[QCL_SiteAllowDelete]
GO

CREATE PROCEDURE [dbo].[QCL_SiteAllowDelete]
	@SiteGroup_id int,
	@PracticeSite_id int
AS

--Return 1 if facility can be deleted otherwise return 0
IF EXISTS ( SELECT * FROM SampleUnit su inner join
			SamplePlan sp on su.sampleplan_id = sp.SAMPLEPLAN_ID
			WHERE (SUFacility_id = @PracticeSite_id 
			OR SUFacility_id in (select PracticeSite_id from PracticeSite where SiteGroup_ID = @SiteGroup_id))
			AND exists(select dbo.SurveyProperty('FacilitiesArePracticeSites',null, sp.SURVEY_ID)))
	SELECT 0
ELSE
	SELECT 1

GO

--rollback tran

commit tran