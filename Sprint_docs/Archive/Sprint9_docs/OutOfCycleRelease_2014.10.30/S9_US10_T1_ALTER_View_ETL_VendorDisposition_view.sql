/*
S9.US10	HCAHPS Phone Lag Time Fix
		As an Authorized Vendor, we want to correctly calculate the lag time for phone non-response dispositions, so that we can report correct data to CMS

T10.1	Add IsFinal column to database (vendor disposition table) and inserting records

Tim Butler

ALTER View [dbo].[ETL_VendorDisposition_view] 
*/

USE [QP_Prod]
GO

/****** Object:  View [dbo].[ETL_VendorDisposition_view]    Script Date: 11/3/2014 1:54:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[ETL_VendorDisposition_view]      
as      
      
select       
vdl.VendorDispositionLog_ID,      
vdl.Vendor_ID,      
vdl.DL_LithoCode_ID,  
scm.Samplepop_ID,    
dll.strLithoCode,      
sd.Study_ID,      
sd.Survey_ID,      
DispositionDate,      
vd.VendorDispositionCode,      
vd.VendorDispositionLabel,       
vd.VendorDispositionDesc,       
vd.Disposition_ID NRCDispositionID,      
vdl.DateCreated,      
vdl.SurveyDataLoad_ID,      
vdl.IsFinal,      
0 BitEvaluated      
from VendorDispositionLog vdl, VendorDispositions vd, dl_surveydataLoad dls,       
  survey_def sd, DL_lithocodes dll, scheduledmailing scm, sentmailing sm      
where vd.VendorDisposition_ID = vdl.VendorDisposition_ID      
  AND vdl.surveyDataLoad_Id = dls.surveyDataLoad_Id       
  AND dls.survey_Id  = sd.survey_ID       
  AND sm.strlithocode = dll.strlithocode 
  AND sm.sentmail_ID = scm.sentmail_ID
  AND vdl.dl_lithocode_ID = dll.dl_lithocode_ID       
  AND vdl.dateCreated > dateadd(d, -7, getdate())

GO


