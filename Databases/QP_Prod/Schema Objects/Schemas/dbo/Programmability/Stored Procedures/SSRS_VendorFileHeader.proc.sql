/*********************************************************************************************************
SSRS_VendorFileHeader
Created by: Michael Beltz 
Purpose:	This proc is used to create the header file/record for the vendor file validation process.
			it is its own report b/c SSRS cannot accept multiple recordsets in one SP call.

History Log:
Created on: 07/08/09

*********************************************************************************************************/

Create proc SSRS_VendorFileHeader (@VendorFile_ID int)
as
begin



 Select c.STRCLIENT_NM, c.CLIENT_ID, s.STRSTUDY_NM, s.STUDY_ID, sd.STRSURVEY_NM, sd.SURVEY_ID, sd.SURVEYTYPEDEF_ID isHCAHPS,  
		ss.SAMPLESET_ID, ss.DATSAMPLECREATE_DT, ss.tiOversample_flag as Oversample, ms.Vendor_ID, V.VENDOR_NM,  
		ISNULL(VCQ.RecordsInFile, 0) AS RecordsInFile, ISNULL(VCQ.RecordsNoLitho, 0) AS RecordsNoLitho, VCQ.ArchiveFileName, VCQ.DateDataCreated, VCQ.DateFileCreated, msm.MailingStepMethod_nm  
 from	client c, Study s,  Sampleset ss, survey_def sd, VendorFileCreationQueue VCQ,  MailingStepMethod msm,
		mailingstep ms Left Outer Join Vendors V on ms.Vendor_ID =v.vendor_ID
 where	c.Client_ID = s.Client_ID and  
		s.Study_Id = sd.Study_ID and  
		sd.survey_ID = ss.survey_ID and  
		ss.survey_ID= sd.survey_ID and  
		VCQ.sampleset_ID = ss.sampleset_ID and  
		VCQ.Mailingstep_ID = ms.Mailingstep_ID and  
		ms.MailingStepMethod_Id = msm.MailingStepMethod_Id and  
		VCQ.VendorFile_ID = @VendorFile_ID  
		
end


