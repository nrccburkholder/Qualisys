/*
S49 ATL-386 CGCAHPS Practice Site-Facility impact on Medusa.sql

Chris Burkholder

ALTER VIEW [dbo].[Web_SampleUnits_View]

*/


USE [QP_Prod]
GO

/****** Object:  View [dbo].[Web_SampleUnits_View]    Script Date: 5/13/2016 9:42:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Web_SampleUnits_View] AS        
        
SELECT SampleUnit_id, ParentSampleUnit_id, strSampleUnit_nm, sd.Survey_id, sd.Study_id,         
case when inttargetreturn > 0 then 'D' else 'I' end strUnitSelectType, intTier intLevel,         
Reporting_Level_nm strLevel_nm, bitSuppress,bitHCAHPS,bitHHCAHPS,bitCHART,bitMNCM,a.MedicareNumber,         
  MedicareName,MedicareActive,strFacility_nm,City,State,Country,strRegion_nm,AdmitNumber,BedSize,bitPeds,        
  bitTeaching,bitTrauma,bitReligious,bitGovernment,bitRural,bitForProfit,bitRehab,bitCancerCenter,        
  bitPicker,bitFreeStanding,AHA_id, a.PENumber        
FROM SampleUnit su (NOLOCK) 
inner join SamplePlan sp(NOLOCK) on su.SamplePlan_id = sp.SamplePlan_id        
inner join Survey_def sd(NOLOCK) on sp.Survey_id = sd.Survey_id
inner join ReportingHierarchy rh(NOLOCK) on su.Reporting_Hierarchy_id = rh.Reporting_Hierarchy_id
LEFT JOIN     
(        
 SELECT suf.*, strRegion_nm, MedicareName, PENumber, Active as MedicareActive         
 FROM SUFacility suf         
 LEFT JOIN MedicareLookup ml ON suf.MedicareNumber=ml.MedicareNumber        
 LEFT JOIN Region r ON suf.Region_id=r.Region_id    
 ) a        
ON su.SUFacility_id=a.SUFacility_id
AND dbo.SurveyProperty('FacilitiesArePracticeSites',null,sp.Survey_ID) <> 1

GO


