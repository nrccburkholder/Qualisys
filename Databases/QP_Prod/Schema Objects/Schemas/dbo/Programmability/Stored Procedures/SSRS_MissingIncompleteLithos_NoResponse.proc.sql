create proc SSRS_MissingIncompleteLithos_NoResponse (@Sampleset_ID int)
as

--declare @Sampleset_ID int
--set @Sampleset_ID = (464374)


--shows all dispositions
select      ss.sampleset_ID, sp.samplepop_ID, qf.questionform_ID, sm.sentmail_ID, sm.strlithocode, vdl.vendor_ID, vd.vendorDispositionCode, vdl.DispositionDate, vdl.isfinal
into  #AlldispositionsRecords
from  dl_lithocodes dl_L, VendorDispositionLog vdl, vendordispositions vd,
            sampleset ss, samplepop sp, questionform qf, sentmailing sm
where ss.sampleset_ID= sp.sampleset_ID and
            sp.samplepop_ID = qf.samplepop_Id and
            qf.sentmail_ID = sm.sentmail_ID and
            sm.strlithocode = dl_L.strlithocode and         
            vdl.dl_lithocode_ID = dl_L.dl_lithocode_ID and
            vdl.vendordisposition_Id = vd.vendordisposition_Id and
            ss.sampleset_ID = @Sampleset_ID 
            

--shows all isFinal dispositions
select      ss.sampleset_ID, sp.samplepop_ID, qf.questionform_ID, sm.sentmail_ID, sm.strlithocode, vdl.vendor_ID, vd.vendorDispositionCode, vdl.DispositionDate, vdl.isfinal
into  #AllIsFinalDispositionsRecords
from  dl_lithocodes dl_L, VendorDispositionLog vdl, vendordispositions vd,
            sampleset ss, samplepop sp, questionform qf, sentmailing sm
where ss.sampleset_ID= sp.sampleset_ID and
            sp.samplepop_ID = qf.samplepop_Id and
            qf.sentmail_ID = sm.sentmail_ID and
            sm.strlithocode = dl_L.strlithocode and         
            vdl.dl_lithocode_ID = dl_L.dl_lithocode_ID and
            vdl.vendordisposition_Id = vd.vendordisposition_Id and
            ss.sampleset_ID = @Sampleset_ID and
			dl_L.bitsubmitted = 1 and
            vdl.isfinal = 1


--shows all isFinal = 0 dispositions
select      ss.sampleset_ID, sp.samplepop_ID, qf.questionform_ID, sm.sentmail_ID, sm.strlithocode, vdl.vendor_ID, vd.vendorDispositionCode, vdl.DispositionDate, vdl.isfinal
into  #AllNonIsFinalDispositionsRecords
from  dl_lithocodes dl_L, VendorDispositionLog vdl, vendordispositions vd,
            sampleset ss, samplepop sp, questionform qf, sentmailing sm
where ss.sampleset_ID= sp.sampleset_ID and
            sp.samplepop_ID = qf.samplepop_Id and
            qf.sentmail_ID = sm.sentmail_ID and
            sm.strlithocode = dl_L.strlithocode and         
            vdl.dl_lithocode_ID = dl_L.dl_lithocode_ID and
            vdl.vendordisposition_Id = vd.vendordisposition_Id and
            ss.sampleset_ID = @Sampleset_ID and
            vdl.isfinal = 0


--shows where no dispositions exist at all
select      ss.sampleset_ID, sp.samplepop_ID, sm.strlithocode 
from  sampleset ss, samplepop sp, questionform qf, sentmailing sm
where ss.sampleset_ID= sp.sampleset_ID and
            sp.samplepop_ID = qf.samplepop_Id and
            qf.sentmail_ID = sm.sentmail_ID and       
            ss.sampleset_ID = @Sampleset_ID and
            sm.strlithocode not in (select strlithocode from #AlldispositionsRecords) 
            




IF OBJECT_ID('tempdb..#AlldispositionsRecords') IS NOT NULL drop table #AlldispositionsRecords
IF OBJECT_ID('tempdb..#AllIsFinalDispositionsRecords') IS NOT NULL drop table #AllIsFinalDispositionsRecords
IF OBJECT_ID('tempdb..#AllNonIsFinalDispositionsRecords') IS NOT NULL drop table #AllNonIsFinalDispositionsRecords


