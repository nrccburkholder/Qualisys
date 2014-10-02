CREATE proc [dbo].[SSRS_QP_REP_SampleSetJustification] (@StartDate datetime = null, @Enddate Datetime = null, @LateOnly bit = 0)    
as    
begin    
     
    
--    
-- --Debug Code    
-- declare @StartDate datetime, @Enddate Datetime    
-- set @StartDate = '2008-01-01 00:00:00'    
-- set @Enddate = '2009-04-01 00:00:00'    
      
if @StartDate is null    
 set @startDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GetDate()), 0)    
    
if @EndDate is null    
 set @EndDate = dateadd(month,1, @StartDate)    
    
 select v.Vendor_ID, css.client_ID, css.Study_ID, css.Survey_ID, ss.sampleset_ID,     
   v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt,     
   d.strDispositionLabel, dbo.fn_GetNumPeopleSampled(ss.SAMPLESET_ID, null, null) as NumberSampled,  count(distinct sm.strlithocode) as counts, 
   vfcq.DateFileCreated, CASE WHEN ms.DaysInField = 17 THEN 18 ELSE ms.DaysInField END as DaysInField, 
   DateAdd(DAY, CASE WHEN ms.DaysInField = 17 THEN 18 ELSE ms.DaysInField END, vfcq.DateFileCreated ) as SampleSetCompleteDate, 
   Reverse(substring(Reverse(vfcq.archivefilename),0,charindex('\',Reverse(vfcq.archivefilename)))) as archivefilename,
   ss.datDateRange_FromDate, ss.datDateRange_ToDate
 from sampleset ss (NOLOCK), samplepop sp (NOLOCK), scheduledmailing scm (NOLOCK),     
   sentmailing sm (NOLOCK), DL_lithoCodes dl_Lithos (NOLOCK), questionform qf (NOLOCK),     
   vendordispositionlog vdl (NOLOCK), vendordispositions vd (NOLOCK), Disposition d (NOLOCK), vendors v (NOLOCK), css_view css  (NOLOCK),
   vendorfilecreationqueue vfcq (NOLOCK), mailingstep ms (NOLOCK)      
 where 	ms.STRMAILINGSTEP_NM like '%Phone%' 	and
   ss.sampleset_ID = sp.sampleset_ID and    
   sp.samplepop_ID = scm.samplepop_ID and    
   scm.sentmail_Id = sm.sentmail_ID and    
   sm.strlithocode = dl_lithos.strlithocode and    
   dl_lithos.DL_LithoCode_ID = vdl.DL_LithoCode_ID and    
   vdl.VendorDisposition_ID = vd.VendorDisposition_ID and    
   vd.Disposition_Id = d.Disposition_ID and    
   vd.Vendor_ID = v.vendor_ID and     
   ss.survey_ID = css.Survey_ID and    
   qf.survey_Id = ss.survey_Id and    
   qf.samplepop_Id = sp.samplepop_ID and    
   vfcq.Sampleset_ID = ss.SAMPLESET_ID and    
   qf.survey_id = ms.survey_id and ms.DaysInField <> 0 and
   ss.datsamplecreate_dt between @StartDate and @Enddate and    
   vdl.isFinal = 1 and    
   dl_lithos.bitSubmitted = 1 and
   (@LateOnly <> 1 or DateAdd(DAY, CASE WHEN ms.DaysInField = 17 THEN 18 ELSE ms.DaysInField END, vfcq.DateFileCreated ) < Convert(Date,GetDate()))
 group by v.Vendor_ID, css.client_ID, css.Study_ID, css.Survey_ID, ss.sampleset_ID,v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt, d.strDispositionLabel,
	vfcq.DateFileCreated, CASE WHEN ms.DaysInField = 17 THEN 18 ELSE ms.DaysInField END, DateAdd(DAY, CASE WHEN ms.DaysInField = 17 THEN 18 ELSE ms.DaysInField END, vfcq.DateFileCreated ), vfcq.ArchiveFileName,ss.datDateRange_FromDate, ss.datDateRange_ToDate    
 having (@LateOnly <> 1 or (dbo.fn_GetNumPeopleReturned(ss.sampleset_id, null, null) < dbo.fn_GetNumPeopleSampled(ss.sampleset_id, null, null)))
 order by v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt, d.strDispositionLabel    
    
end    

