CREATE Proc SSRS_QP_Rep_GetDispostionCountByReceiptType (@StartDate datetime = null, @EndDate datetime = null, @ReceiptType varchar(1000) = null, @Disposition_IDs varchar(1000) = null)    
as    
 begin    
    
 declare @SQL varchar(8000)    
     
 if @StartDate is null    
  set @StartDate = dateadd(d,-7,getdate())    
 else    
  set @StartDate = convert(varchar, @StartDate, 111)    
    
 if @EndDate is null    
  set @EndDate = getdate()    
 else    
  set @EndDate = convert(varchar, @EndDate, 111)    
    
    
 set @SQL = '    
 select DL_D.Vendor_ID, V.Vendor_nm, DATEADD(dd, DATEDIFF(dd, 0, qf.datResultsImported),0) as DateImported, css.client_ID, css.strclient_nm,   
 css.study_ID, css.strStudy_nm, css.survey_ID, css.strsurvey_nm,  
 isnull(rt.ReceiptType_nm, ''UNKNOWN'') as ReceiptType_nm, d.strReportLabel,   
 count(distinct sm.sentmail_ID) as counts    
 from Dispositionlog dl, samplepop sp (NOLOCK), sampleset ss (NOLOCK),     
  css_view css (NOLOCK), questionform qf (NOLOCK), receiptType rt (NOLOCK),    
  Disposition d (NOLOCK), sentmailing sm (NOLOCK), DL_lithoCodes dl_L (NOLOCK),     
  dl_surveyDataLoad dl_S (NOLOCK), DL_DataLoad DL_D (NOLOCK), Vendors V (Nolock)  
 where dl.samplepop_ID = sp.samplepop_ID and    
  sp.sampleset_ID = ss.sampleset_ID and    
  ss.survey_Id = css.survey_ID and    
  sp.samplepop_ID = qf.samplepop_ID and    
  isnull(qf.receiptType_ID, 0) = rt.receiptType_ID and    
  dl.disposition_ID = d.disposition_ID and  
  qf.sentmail_ID = sm.sentmail_ID and  
  sm.strLithoCode = dl_L.strlithocode and   
  dl_L.SurveyDataLoad_ID = dl_S.SurveyDataLoad_ID and  
  DL_D.DataLoad_ID = DL_S.DataLoad_ID and  
  DL_D.vendor_ID = V.Vendor_ID and  
   qf.datResultsImported between ''' + cast(convert(varchar, @StartDate, 111) as varchar(100))  + ' 00:00:00'' and ''' + cast(convert(varchar, @EndDate, 111) as varchar(100)) + ' 23:59:59'''    
    
    
 if @ReceiptType is not null    
  begin    
   set @SQL = @SQL + ' and qf.receiptType_ID in (' + @ReceiptType + ') '    
  end    
       
 if @Disposition_IDs is not null    
  begin    
   set @SQL = @SQL + ' and dl.disposition_ID in (' + @Disposition_IDs + ') '    
  end    
    
    
 set @SQL = @SQL + '    
 group by DL_D.Vendor_ID, V.Vendor_nm, DATEADD(dd, DATEDIFF(dd, 0, qf.datResultsImported),0), css.client_ID, css.strclient_nm, css.study_ID, css.strStudy_nm,     
   css.survey_ID, css.strsurvey_nm,  rt.ReceiptType_nm, d.strReportLabel     
 order by V.Vendor_nm, DateImported,  css.strclient_nm, css.strStudy_nm, css.strsurvey_nm,  isnull(rt.ReceiptType_nm, ''UNKNOWN'')    
 '    
    
 print @SQL    
 exec (@SQL)    
    
end


