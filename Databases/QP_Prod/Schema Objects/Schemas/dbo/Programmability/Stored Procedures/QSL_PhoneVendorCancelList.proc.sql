-- =============================================
-- Author:		Chris Burkholder
-- Create date: Valentine's Day, 2014
-- Description:	Gets Lithos and Survey_Id's to strike from Phone Vendor's to do list
-- =============================================
CREATE PROCEDURE QSL_PhoneVendorCancelList
	@Vendor_Id int = null
AS
BEGIN

insert into PhoneVendorCancelListLog (Survey_id, StrLithoCode, Vendor_id)
select distinct sd.survey_id, sm.STRLITHOCODE, ms.Vendor_id from SCHEDULEDMAILING schm
inner join sentmailing sm on schm.SENTMAIL_ID = sm.SENTMAIL_ID
inner join samplePop sp on schm.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
inner join survey_def sd on sp.STUDY_ID = sd.STUDY_ID
inner join mailingstep ms on schm.MAILINGSTEP_ID = ms.MAILINGSTEP_ID
inner join sampleset ss on ss.SURVEY_ID = sd.SURVEY_ID
right join (Select distinct dl.SamplePop_id
From Scheduledmailing schm
      inner join Samplepop sp   on schm.samplepop_ID = sp.samplepop_ID
      inner join SentMailing sm on schm.sentMail_ID = sm.sentmail_id
      inner join Dispositionlog dl on schm.samplepop_ID = dl.samplepop_ID
Where (dl.Disposition_id in (13, 19, 20, 3, 24, 2, 8))
) rj on sp.SAMPLEPOP_ID = rj.SamplePop_id
and sm.STRLITHOCODE not in (select STRLITHOCODE from PhoneVendorCancelListLog)
where ms.STRMAILINGSTEP_NM like '%Phone%' and ms.INTSEQUENCE > 1 
and getdate() < sm.datExpire
and rj.SamplePop_id is not null
and (@Vendor_Id is null or (ms.Vendor_ID = @Vendor_Id))

select Survey_id, StrLithoCode as 'Litho' from PhoneVendorCancelListLog 
where datSentToVendor is null
  and (@Vendor_Id is null or (Vendor_ID = @Vendor_Id))
order by survey_id, strlithocode
END


