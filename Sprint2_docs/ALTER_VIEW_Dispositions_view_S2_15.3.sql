USE [QP_Prod]
GO

/****** Object:  View [dbo].[Dispositions_view]    Script Date: 6/13/2014 10:20:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[Dispositions_view]  
as  
  
Select	d.* 
		,hd.Value HCAHPSValue 
		,hd.Hierarchy HCAHPSHierarchy
		,hd.[Desc] HCAHPSDesc 
		,hhd.Value HHCAHPSValue 
		,hhd.Hierarchy HHCAHPSHierarchy 
		,hhd.[Desc] HHCAHPSDesc
		,mncm.Value MNCMValue 
		,mncm.Hierarchy MNCMHierarchy 
		,mncm.[Desc] MNCMDesc
		,aco.Value ACOCAHPSValue 
		,aco.Hierarchy ACOCAHPSHierarchy 
		,aco.[Desc] ACOCAHPSDesc
		,ich.Value ICHCAHPSValue 
		,ich.Hierarchy ICHCAHPSHierarchy 
		,ich.[Desc] ICHCAHPSDesc
		
from Disposition d 
		left outer join SurveyTypeDispositions hd on d.Disposition_id = hd.Disposition_ID and hd.SurveyType_ID = 2
		left outer join SurveyTypeDispositions hhd on d.Disposition_id = hhd.Disposition_ID and hhd.SurveyType_ID = 3
		left outer join SurveyTypeDispositions mncm on d.Disposition_id = mncm.Disposition_ID and mncm.SurveyType_ID = 4
		left outer join SurveyTypeDispositions aco on d.Disposition_id = aco.Disposition_ID and aco.SurveyType_ID = 10
		left outer join SurveyTypeDispositions ich on d.Disposition_id = ich.Disposition_ID and aco.SurveyType_ID = 11

GO


