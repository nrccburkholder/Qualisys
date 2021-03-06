USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SSRS_QP_REP_VendorFileValidation]    Script Date: 5/28/2014 9:03:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER 
proc [dbo].[SSRS_QP_REP_VendorFileValidation] (@SampleDate datetime = null)    
as    
begin    
     
    
--    
-- --Debug Code    
-- declare @StartDate datetime, @Enddate Datetime    
-- set @StartDate = '2008-01-01 00:00:00'    
-- set @Enddate = '2009-04-01 00:00:00'    

if @SampleDate is null
	set @SampleDate = CONVERT(date, getdate())
   
  select 
   css.Client_ID,
   css.strClient_Nm, 
   css.strStudy_nm, 
   css.Study_ID,
   css.strSurvey_nm, 
   css.Survey_ID,  
   ss.sampleset_ID,
   Reverse(substring(Reverse(vfcq.archivefilename),0,charindex('\',Reverse(vfcq.archivefilename)))) as FileNam,
   --convert(nvarchar, Convert(Date, ss.datDateRange_FromDate, 100)) + ' to ' + convert(nvarchar, Convert(Date, ss.datDateRange_ToDate, 100)) 
   convert(varchar, month(ss.datDateRange_FromDate), 0) + '/' + convert(varchar(2), day(ss.datDateRange_FromDate), 0) + '-' + convert(varchar(2), month(ss.datDateRange_ToDate), 0) + '/' + convert(varchar(2), day(ss.datDateRange_ToDate), 0) as DateRange,
--   count(distinct sm.strlithocode) as Counts, 
   ss.datsamplecreate_dt,
--   IsNull(d.strDispositionLabel, 'Disposition NA') as strDispositionLabel, 
   dbo.fn_GetNumPeopleSampled(ss.Sampleset_ID, '%Phone%', null) as NumberSampled,  
   sm.DATMAILED as datLastMailed,
   vfcq.DateFileCreated as datgenerate,
   DateAdd(DAY, ms.DaysInField, vfcq.DateFileCreated) as DueDate,
   ss.strSampleSurvey_nm as SampleSet,
   v.Vendor_nm as Vendor
 from sampleset ss (NOLOCK) inner join samplepop sp (NOLOCK) on ss.sampleset_ID = sp.sampleset_ID
	inner join scheduledmailing scm (NOLOCK) on sp.samplepop_ID = scm.samplepop_ID     
    inner join sentmailing sm (NOLOCK) on scm.sentmail_Id = sm.sentmail_ID 
	inner join questionform qf (NOLOCK) on qf.samplepop_Id = sp.samplepop_ID
	inner join mailingstep ms (NOLOCK) on ms.MAILINGSTEP_ID = scm.MAILINGSTEP_ID
	inner join vendors v (NOLOCK) on ms.Vendor_ID = v.vendor_ID
	inner join css_view css (NOLOCK) on ss.survey_ID = css.Survey_ID
	inner join vendorfilecreationqueue vfcq (NOLOCK) on vfcq.Sampleset_ID = ss.SAMPLESET_ID
/*	full join DL_lithoCodes dl_Lithos (NOLOCK) on sm.strlithocode = dl_lithos.strlithocode
	full join VendorDispositionLog vdl (NOLOCK) on dl_lithos.DL_LithoCode_ID = vdl.DL_LithoCode_ID
	full join VendorDispositions vd (NOLOCK) on vdl.VendorDisposition_ID = vd.VendorDisposition_ID
	full join Disposition d (NOLOCK) on vd.Disposition_Id = d.Disposition_ID*/
 where 	
	ms.STRMAILINGSTEP_NM like '%Phone%' 	and
	ms.DaysInField <> 0 and
   CONVERT(date,  ss.datsamplecreate_dt) = @SampleDate 
 group by    css.CLIENT_ID,
   css.strClient_Nm, 
   css.strStudy_nm, 
   css.STUDY_ID,
   css.strSurvey_nm, 
   css.Survey_ID,  
   ss.sampleset_ID,
   vfcq.archivefilename,
   --convert(nvarchar, Convert(Date, ss.datDateRange_FromDate, 100)) + ' to ' + convert(nvarchar, Convert(Date, ss.datDateRange_ToDate, 100)),
   convert(varchar, month(ss.datDateRange_FromDate), 0) + '/' + convert(varchar(2), day(ss.datDateRange_FromDate), 0) + '-' + convert(varchar(2), month(ss.datDateRange_ToDate), 0) + '/' + convert(varchar(2), day(ss.datDateRange_ToDate), 0),
   ss.datsamplecreate_dt,
--   IsNull(d.strDispositionLabel, 'Disposition NA'), 
   dbo.fn_GetNumPeopleSampled(ss.Sampleset_ID, '%Phone%', null),
   sm.DATMAILED,
   vfcq.DateFileCreated,
   DateAdd(DAY, ms.DaysInField, vfcq.DateFileCreated),
   ss.strSampleSurvey_nm,
   v.Vendor_nm
 order by v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt
    
end    

