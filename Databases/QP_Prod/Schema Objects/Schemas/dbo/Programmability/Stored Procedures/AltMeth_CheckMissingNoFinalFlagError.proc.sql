CREATE Proc AltMeth_CheckMissingNoFinalFlagError (@strlithocode_ID varchar(15))
as
begin

declare @errMsg varchar(1000)

--show all data
select	distinct dl.Vendor_ID, sdl.Survey_ID, dl.DataLoad_ID, sdl.SurveyDataLoad_ID, lc.DL_LithoCode_ID, lc.strLithoCode, 
		lc.bitIgnore, lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated,
		dd.DL_Disposition_ID, dd.DispositionDate, dd.VendorDispositionCode, vd.VendorDispositionLabel, dd.IsFinal
from DL_LithoCodes lc, DL_Dispositions dd, DL_SurveyDataLoad sdl, DL_DataLoad dl, VendorDispositions vd
where	lc.DL_LithoCode_ID = dd.DL_LithoCode_ID and
		lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID and
		sdl.DataLoad_ID = dl.DataLoad_ID and
		dd.VendorDispositionCode = vd.VendorDispositionCode and
		dl.Vendor_ID = vd.Vendor_ID and
		lc.strLithoCode = @strlithocode_ID
order by lc.DateCreated

--show what appears to be incorrect data
select	distinct dl.Vendor_ID, sdl.Survey_ID, dl.DataLoad_ID, sdl.SurveyDataLoad_ID, lc.strLithoCode,lc.DL_LithoCode_ID, 
		lc.bitIgnore, lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated,
		dd.DL_Disposition_ID, dd.DispositionDate, dd.VendorDispositionCode, vd.VendorDispositionLabel, dd.IsFinal
into	#ErrData
from DL_LithoCodes lc, DL_Dispositions dd, DL_SurveyDataLoad sdl, DL_DataLoad dl, VendorDispositions vd
where	lc.DL_LithoCode_ID = dd.DL_LithoCode_ID and
		lc.SurveyDataLoad_ID = sdl.SurveyDataLoad_ID and
		sdl.DataLoad_ID = dl.DataLoad_ID and
		dd.VendorDispositionCode = vd.VendorDispositionCode and
		dl.Vendor_ID = vd.Vendor_ID and
		lc.strLithoCode = @strlithocode_ID and
		dd.IsFinal = 1 and
		lc.bitSubmitted <> 1 and
		lc.bitSkipDuplicate = 0
order by lc.DateCreated

select * from #ErrData

select @errMsg = 'Begin tran
Update DL_Lithocodes set bitSubmitted = 1 where dl_lithocode_ID = ' + CAST(DL_LithoCode_ID as varchar(10)) + '
--check to make sure only on record is updated
Rollback Tran  --If more than one record is updated
Commit Tran	--if one record is updated'
From	#ErrData

print 	@errMsg   

end


