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

DROP TABLE [dbo].[ClientPracticeSiteLookup]
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
/*
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
*/
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectAllFacilities]    Script Date: 9/28/2015 12:40:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

	  
ALTER PROCEDURE [dbo].[QCL_SelectAllFacilities]  
AS    
begin
	CREATE TABLE #t (  
	SUFacility_id INT,  
	strFacility_nm VARCHAR(100),  
	City VARCHAR(42),  
	State VARCHAR(2),  
	Country VARCHAR(42),  
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
	  
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)  
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName  
	FROM SUFacility suf 
	--LEFT JOIN MedicareLookup ml  
	--ON suf.MedicareNumber=ml.MedicareNumber  
	ORDER BY strFacility_nm, City  
	  
	UPDATE t  
	SET t.IsHCAHPSAssigned=1  
	FROM #t t, SampleUnit su  
	WHERE t.SUFacility_id=su.SUFacility_id and  
	 su.bithcahps=1  
	  
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,  
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,  
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,  
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,--MedicareName,  
	 IsHCAHPSAssigned  
	FROM #t  
	ORDER BY strFacility_nm, City  
	  
	DROP TABLE #t  
	----------------------------  
end	  


GO

------------------------------------------------- refactored 8/12/2015
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectFacilityByAHAId]    Script Date: 9/28/2015 12:40:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



/*          
Business Purpose:           
This procedure is used to support the Qualisys Class Library.  It will return all facilities for an AHAId.      
          
Created: 3/14/2006 by DC      
          
Modified: 7/30/08 MB Removed join to MedicareLookup as it is no longer needed
        
      
*/              
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByAHAId]      
@AHA_ID INT      
AS    
begin    
	SET NOCOUNT ON    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	    
	CREATE TABLE #t (    
	SUFacility_id INT,    
	strFacility_nm VARCHAR(100),    
	City VARCHAR(42),    
	State VARCHAR(2),    
	Country VARCHAR(42),    
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
	    
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,    
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,    
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,    
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)    
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,    
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,    
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,    
	 bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName    
	FROM SUFacility suf 
	--LEFT JOIN MedicareLookup ml    
	--ON suf.MedicareNumber=ml.MedicareNumber    
	WHERE AHA_id=@AHA_id      
	    
	UPDATE t    
	SET t.IsHCAHPSAssigned=1    
	FROM #t t, SampleUnit su    
	WHERE t.SUFacility_id=su.SUFacility_id and    
	 su.bithcahps=1    
	    
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,    
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,    
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,    
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,
	--MedicareName,    
	 IsHCAHPSAssigned    
	FROM #t    
	ORDER BY strFacility_nm, City    
	    
	DROP TABLE #t    
	    
	SET NOCOUNT OFF    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
	---------------------------------------    
end

GO

------------------------------------------------- refactored 8/12/2015
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectFacilityByClientId]    Script Date: 9/28/2015 12:41:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



/*              
Business Purpose:               
This procedure is used to support the Qualisys Class Library.  It will return all facilities for a client.          
              
Created: 3/14/2006 by DC          
              
Modified:              
            
          
*/    
ALTER PROCEDURE [dbo].[QCL_SelectFacilityByClientId]    
@Client_id INT    
AS    
BEGIN    
	SET NOCOUNT ON    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
	    
	CREATE TABLE #t (    
	SUFacility_id INT,    
	strFacility_nm VARCHAR(100),    
	City VARCHAR(42),    
	State VARCHAR(2),    
	Country VARCHAR(42),    
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
	MedicareName VARCHAR(200),    
	IsHCAHPSAssigned BIT DEFAULT(0)    
	)    
	    
	INSERT INTO #t (SUFacility_id,strFacility_nm,City,State,Country,Region_id,    
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,    
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,    
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber
	--,MedicareName
	)    
	SELECT suf.SUFacility_id,strFacility_nm,City,State,Country,    
	  Region_id,AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,    
	  bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,    
	  bitCancerCenter,bitPicker,bitFreeStanding,AHA_id,suf.MedicareNumber
	--,MedicareName    
	FROM ClientSUFacilityLookup cf, SUFacility suf 
	--LEFT JOIN MedicareLookup ml    
	--ON suf.MedicareNumber=ml.MedicareNumber    
	WHERE cf.Client_id=@Client_Id    
	AND cf.SUFacility_id=suf.SUFacility_id    
	    
	UPDATE t    
	SET t.IsHCAHPSAssigned=1    
	FROM #t t, SampleUnit su    
	WHERE t.SUFacility_id=su.SUFacility_id and    
	 su.bithcahps=1    
	    
	SELECT SUFacility_id,strFacility_nm,City,State,Country,Region_id,    
	 AdmitNumber,BedSize,bitPeds,bitTeaching,bitTrauma,bitReligious,    
	 bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,    
	 bitPicker,bitFreeStanding,AHA_id,MedicareNumber,
	--MedicareName,    
	 IsHCAHPSAssigned    
	FROM #t    
	ORDER BY strFacility_nm, City    
	    
	DROP TABLE #t    
	    
	SET NOCOUNT OFF    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
	    
	----------------------------------------- 
END

GO

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_AssignFacilityToClient]    Script Date: 9/28/2015 12:42:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[QCL_AssignFacilityToClient]
@SUFacilityID INT,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

EXEC QCL_UnassignFacilityFromClient @SUFacilityID, @ClientID

INSERT INTO ClientSUFacilityLookup (Client_id, SUFacility_id)
SELECT @ClientID, @SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO

/****** Object:  StoredProcedure [dbo].[QCL_UnassignFacilityFromClient]    Script Date: 8/13/2015 9:16:45 AM ******/

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_UnassignFacilityFromClient]    Script Date: 9/28/2015 12:42:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[QCL_UnassignFacilityFromClient]
@SUFacilityID INT,
@ClientID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DELETE ClientSUFacilityLookup
WHERE Client_id=@ClientID
AND SUFacility_id=@SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


GO


/****** Object:  StoredProcedure [dbo].[QCL_AllowUnassignmentFacility]    Script Date: 8/13/2015 9:16:45 AM ******/

USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_AllowUnassignmentFacility]    Script Date: 9/28/2015 12:42:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----------------------------
ALTER PROCEDURE [dbo].[QCL_AllowUnassignmentFacility]
@FacilityId INT,
@ClientId INT
AS

--Return 1 if facility can be unassigned, otherwise return 0
IF EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s 
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT 1
END
----------------------------

GO

/*
if not exists(select 1 from Qualpro_params where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS')
insert into Qualpro_params (strparam_nm, strparam_type, strparam_grp, strparam_value, COMMENTS)
select Replace(STRPARAM_NM,'MedicareIdTextMayBeBlank','FacilitiesArePracticeSites'), STRPARAM_TYPE, STRPARAM_GRP, 0, 'Facilities Are in PracticeSite not SUFacility for CGCAHPS' from qualpro_params where strparam_nm = 'SurveyRule: MedicareIdTextMayBeBlank - CGCAHPS'
*/
delete Qualpro_params where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS'

GO

commit tran