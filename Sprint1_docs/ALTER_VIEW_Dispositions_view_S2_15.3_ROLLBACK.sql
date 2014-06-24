USE [QP_Prod]
GO

/****** Object:  View [dbo].[Dispositions_view]    Script Date: 6/13/2014 2:21:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[Dispositions_view]  
as  
  
Select	d.*, 
		hd.HCAHPSValue, hd.HCAHPSHierarchy,hd.HCAHPSDesc, 
		hhd.HHCAHPSValue, hhd.HHCAHPSHierarchy, hhd.HHCAHPSDesc,
		mncm.MNCMValue, mncm.MNCMHierarchy, mncm.MNCMDesc,
		aco.ACOCAHPSValue, aco.ACOCAHPSHierarchy, aco.ACOCAHPSDesc  
		
from Disposition d 
		left outer join HCAHPSDispositions hd on d.Disposition_id = hd.Disposition_ID  
		left outer join  HHCAHPSDispositions hhd on d.Disposition_id = hhd.Disposition_ID  
		left outer join  MNCMDispositions mncm on d.Disposition_id = mncm.Disposition_ID  
		left outer join  ACOCAHPSDispositions aco on d.Disposition_id = aco.Disposition_ID

GO


