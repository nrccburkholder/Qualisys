CREATE Proc SSRS_MissingIncompleteLithos_RolledBack (@Sampleset_ID int)
as

select	Distinct sp.samplepop_ID, sm.strlithocode, sr.strNTLogin_nm, strWorkstation, datReset 
from	sampleset ss, samplepop sp, scheduledmailing scm, sentmailing sm, scanningresets sr, 
		dl_lithoCodes dll, vendordispositionLog vdl
where	ss.sampleset_ID = sp.sampleset_ID and
		sp.samplepop_ID = scm.samplepop_ID and
		scm.sentmail_ID = sm.sentmail_Id and
		sm.strlithocode = sr.strlithocode and
		dll.strlithocode = sm.strlithocode and
		vdl.dl_lithocode_Id = dll.dl_lithocode_Id and
		dll.bitsubmitted = 0 and
		vdl.isfinal = 1 and
		ss.sampleset_ID = @Sampleset_ID


