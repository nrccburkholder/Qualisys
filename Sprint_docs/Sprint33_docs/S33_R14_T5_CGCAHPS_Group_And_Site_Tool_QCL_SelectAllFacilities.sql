/*
-- =============================================
-- S33_R14_T5_CGCAHPS_Group_And_Site_Tool_QCL_SelectAllFacilities.sql
-- Create date: August, 2015
-- Description:	Modify Configuration Manager to fix assign to clients to use groups not sites

ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByClientId]

ALTER PROCEDURE [dbo].[QCL_AssignFacilityToClient]
ALTER PROCEDURE [dbo].[QCL_UnassignFacilityFromClient]

ALTER PROCEDURE [dbo].[QCL_AllowUnassignmentFacility]

CREATE TABLE [dbo].[ClientPracticeSiteLookup]
-- =============================================
*/
USE [QP_Prod]
GO

begin tran

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ClientPracticeSiteGroupLookup'))
	ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] DROP CONSTRAINT [FK_CPSG_PracticeSiteGroup]
GO

IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ClientPracticeSiteGroupLookup'))
	ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] DROP CONSTRAINT [FK_CPSG_Client]
GO

/****** Object:  Table [dbo].[ClientPracticeSiteGroupLookup]    Script Date: 8/13/2015 9:32:03 AM ******/
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ClientPracticeSiteGroupLookup'))
	DROP TABLE [dbo].[ClientPracticeSiteGroupLookup]
GO

/****** Object:  Table [dbo].[ClientPracticeSiteGroupLookup]    Script Date: 8/13/2015 9:32:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClientPracticeSiteGroupLookup](
	[Client_id] [int] NOT NULL,
	[SiteGroup_id] [int] NOT NULL,
	CONSTRAINT [PK_CPSG_ClientPracticeSite] PRIMARY KEY CLUSTERED 
(
	[Client_id] ASC,
	[SiteGroup_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup]  WITH CHECK ADD  CONSTRAINT [FK_CPSG_Client] FOREIGN KEY([Client_id])
REFERENCES [dbo].[CLIENT] ([CLIENT_ID])
GO

ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] CHECK CONSTRAINT [FK_CPSG_Client]
GO

ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup]  WITH CHECK ADD  CONSTRAINT [FK_CPSG_PracticeSiteGroup] FOREIGN KEY([SiteGroup_id])
REFERENCES [dbo].[SiteGroup] ([SiteGroup_id])
GO

ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] CHECK CONSTRAINT [FK_CPSG_PracticeSiteGroup]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectAllFacilities]    Script Date: 8/4/2015 2:23:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]  
@IsPracticeSite bit = null,
@SUFacility_id INT = null,
@Client_id INT = null,
@AHA_id INT = null
AS    
begin
	CREATE TABLE #t (  
	SUFacility_id INT,  
	strFacility_nm VARCHAR(100),  
	City VARCHAR(42),  
	State VARCHAR(2),  
	Country VARCHAR(42),  
	RowType CHAR(1),
	GroupID varchar(12),
	Region_id INT,  
	AdmitNumber INT,  
	BedSize INT,  
	bitPeds BIT,  
	bitTeaching BIT,  
	bitTrauma BIT,  
	bitReligious BIT,  
	bitGovernment BIT,  
	bitRural BIT,  
	bitForProfit BIT,  
	bitRehab BIT,  
	bitCancerCenter BIT,  
	bitPicker BIT,  
	bitFreeStanding BIT,  
	AHA_id INT,  
	MedicareNumber VARCHAR(20),  
	MedicareName VARCHAR(45),  
	IsHCAHPSAssigned BIT DEFAULT(0)  
	)  
	  
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)  
	SELECT distinct suf.SUFacility_id,strFacility_nm,City,State,Country,'F','',Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName  
	FROM SUFacility suf with(NOLOCK)
	left join ClientSUFacilityLookup csuf with(NOLOCK) on suf.SUFacility_id = csuf.SUFacility_id 
	WHERE ((@IsPracticeSite is null) or (@IsPracticeSite = 0))
	AND ((@Client_id is null) or (@Client_id = csuf.Client_id))
	AND ((@SUFacility_id is null) or (@SUFacility_id = suf.SUFacility_id))
	AND ((@AHA_id is null) or (@AHA_id = AHA_id))	
	--LEFT JOIN MedicareLookup ml  
	--ON suf.MedicareNumber=ml.MedicareNumber  
	ORDER BY strFacility_nm, City  

	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)
	SELECT distinct sg.[SiteGroup_ID]
		  ,[GroupName]
		  ,[City]
		  ,[ST]
		  ,'USA','G',convert(varchar(12),sg.[SiteGroup_ID])
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
	  FROM [dbo].[SiteGroup] sg with(NOLOCK)
	  left join ClientPracticeSiteGroupLookup cpsgl with(NOLOCK) on sg.SiteGroup_ID = cpsgl.SiteGroup_id
	  WHERE (@IsPracticeSite is null)
	  AND ((@Client_id is null) or (@Client_id = cpsgl.Client_id))
	  AND (@AHA_id is null)


	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)
	SELECT distinct ps.[PracticeSite_ID]
		  ,ps.[PracticeName]
		  ,ps.[City]
		  ,ps.[ST]
		  ,'USA','G',convert(varchar(12),sg.[SiteGroup_ID])
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
		  ,NULL
	  FROM [dbo].[PracticeSite] ps with (NOLOCK)
	  inner join [dbo].[SiteGroup] sg with(NOLOCK) on ps.SiteGroup_ID = sg.SiteGroup_ID
	  left join ClientPracticeSiteGroupLookup cpsgl with(NOLOCK) on sg.SiteGroup_ID = cpsgl.SiteGroup_id
	  WHERE (@IsPracticeSite = 1)
	  AND ((@Client_id is null) or (@Client_id = cpsgl.Client_id))
	  AND (@AHA_id is null)

	UPDATE t  
	SET t.IsHCAHPSAssigned=1  
	FROM #t t, SampleUnit su  
	WHERE t.SUFacility_id=su.SUFacility_id and  
	 su.bithcahps=1  
	  
	SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,RowType,GroupId,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,--MedicareName,  
	 IsHCAHPSAssigned  
	FROM #t suf
	ORDER BY strFacility_nm, City  
	  
	DROP TABLE #t  
	----------------------------  
end
GO
------------------------------------------------- refactored 8/12/2015
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]
@AHA_ID int
AS
EXEC [dbo].[QCL_SelectAllFacilities] null, null, null, @AHA_id

GO
------------------------------------------------- refactored 8/12/2015
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByClientId]
@Client_id int,
@IncludePracticeSite bit = null
AS
EXEC [dbo].[QCL_SelectAllFacilities] @IncludePracticeSite, null, @Client_id

GO

/****** Object:  StoredProcedure [dbo].[QCL_AssignFacilityToClient]    Script Date: 8/13/2015 9:10:00 AM ******/

ALTER PROCEDURE [dbo].[QCL_AssignFacilityToClient]
@SUFacilityID INT,
@ClientID INT,
@IsPracticeSite bit = false
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

EXEC QCL_UnassignFacilityFromClient @SUFacilityID, @ClientID

IF (@IsPracticeSite = 0)

	INSERT INTO ClientSUFacilityLookup (Client_id, SUFacility_id)
	SELECT @ClientID, @SUFacilityID

Else --@IsPracticeSite = 1

	INSERT INTO ClientPracticeSiteGroupLookup (Client_id, SiteGroup_id )
	SELECT @ClientID, @SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

/****** Object:  StoredProcedure [dbo].[QCL_UnassignFacilityFromClient]    Script Date: 8/13/2015 9:16:45 AM ******/

ALTER PROCEDURE [dbo].[QCL_UnassignFacilityFromClient]
@SUFacilityID INT,
@ClientID INT,
@IsPracticeSite bit = false
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

IF (@IsPracticeSite = 0)

	DELETE ClientSUFacilityLookup
	WHERE Client_id=@ClientID
	AND SUFacility_id=@SUFacilityID

ELSE --@IsPracticeSite = 1

	DELETE ClientPracticeSiteGroupLookup
	WHERE Client_id=@ClientID
	AND SiteGroup_id=@SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

/****** Object:  StoredProcedure [dbo].[QCL_AllowUnassignmentFacility]    Script Date: 8/13/2015 9:16:45 AM ******/

ALTER PROCEDURE [dbo].[QCL_AllowUnassignmentFacility]
@FacilityId INT,
@ClientId INT,
@IsPracticeSite bit = false
AS

--Return 1 if facility can be unassigned, otherwise return 0
IF ((@IsPracticeSite is null) or (@IsPracticeSite = 0)) and EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s, SUFacility suf
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId
					and suf.SUFacility_id = su.SUFacility_id)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	IF (@IsPracticeSite = 1) AND EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s, PracticeSite ps
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId
					and ps.PracticeSite_ID = su.SUFacility_id)
	BEGIN
		SELECT 0
	END
	ELSE
	BEGIN
		SELECT 1
	END
END
----------------------------

GO

if not exists(select 1 from Qualpro_params where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS')
insert into Qualpro_params (strparam_nm, strparam_type, strparam_grp, strparam_value, COMMENTS)
select Replace(STRPARAM_NM,'MedicareIdTextMayBeBlank','FacilitiesArePracticeSites'), STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, 'Facilities Are in PracticeSite not SUFacility for CGCAHPS' from qualpro_params where strparam_nm = 'SurveyRule: MedicareIdTextMayBeBlank - CGCAHPS'

GO

commit tran