CREATE proc SSRS_QP_REP_SampleSetJustification (@StartDate datetime = null, @Enddate Datetime = null)    
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
   d.strDispositionLabel, dbo.fn_GetNumPeopleSampled(ss.Sampleset_ID) as NumberSampled,  count(distinct sm.strlithocode) as counts    
 from sampleset ss (NOLOCK), samplepop sp (NOLOCK), scheduledmailing scm (NOLOCK),     
   sentmailing sm (NOLOCK), DL_lithoCodes dl_Lithos (NOLOCK), questionform qf (NOLOCK),     
   vendordispositionlog vdl (NOLOCK), vendordispositions vd (NOLOCK), Disposition d (NOLOCK), vendors v (NOLOCK), css_view css  (NOLOCK)   
 where ss.sampleset_ID = sp.sampleset_ID and    
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
   ss.datsamplecreate_dt between @StartDate and @Enddate and    
   vdl.isFinal = 1 and    
   dl_lithos.bitSubmitted = 1    
 group by v.Vendor_ID, css.client_ID, css.Study_ID, css.Survey_ID, ss.sampleset_ID,v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt, d.strDispositionLabel    
 order by v.Vendor_nm, css.strClient_Nm, css.strStudy_nm, css.strSurvey_nm, ss.datsamplecreate_dt, d.strDispositionLabel    
    
end


