/*
S56 ATL-708 Phone Vendor Cancel Fix - backout.sql

Litho is included in the phone vendor cancel log due to a breakoff on the phone step in a mixed mode.
Also, vendor cancel log shows one litho tied to multiple surveys. Looks like that's caused by joining from samplepop to survey_def on study_id.
Dana will add more details. 

ATL-722 Phone Vendor Cancellation service

Modify the logic that determines which respondents had a return so that it doesn't include partial phone returns.

Chris Burkholder

8/17/2016

ALTER PROCEDURE [dbo].[QSL_PhoneVendorCancelList]
*/
USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QSL_PhoneVendorCancelList]    Script Date: 8/17/2016 5:00:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Chris Burkholder
-- Create date: Valentine's Day, 2014
-- Description:	Gets Lithos and Survey_Id's to strike from Phone Vendor's to do list
-- =============================================
ALTER PROCEDURE [dbo].[QSL_PhoneVendorCancelList]
	@Vendor_Id int = null
AS
BEGIN

insert into PhoneVendorCancelListLog (Survey_id, StrLithoCode, Vendor_id)
select distinct sd.survey_id, sm.STRLITHOCODE, ms.Vendor_id from SCHEDULEDMAILING schm
inner join sentmailing sm on schm.SENTMAIL_ID = sm.SENTMAIL_ID
inner join samplePop sp on schm.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
inner join survey_def sd on sp.STUDY_ID = sd.STUDY_ID
inner join mailingstep ms on schm.MAILINGSTEP_ID = ms.MAILINGSTEP_ID
inner join (SELECT methodology_id, CAST(MAX(CAST(BITSENDSURVEY as INT)) AS BIT) as 'bitSendSurvey'
			 FROM mailingstep 
			 where strMailingstep_nm not like '%phone%'
			 GROUP BY METHODOLOGY_ID) ms2 on ms2.METHODOLOGY_ID = ms.Methodology_id
inner join sampleset ss on ss.SURVEY_ID = sd.SURVEY_ID
right join (Select distinct dl.SamplePop_id
From Scheduledmailing schm
      inner join Samplepop sp   on schm.samplepop_ID = sp.samplepop_ID
      inner join SentMailing sm on schm.sentMail_ID = sm.sentmail_id
      inner join Dispositionlog dl on schm.samplepop_ID = dl.samplepop_ID
Where (dl.Disposition_id in (13, 19, 20, 3, 24, 2, 8, 11))
						/*	13	Complete and Valid Survey
							19	Complete and Valid Survey by Mail
							20	Complete and Valid Survey by Phone
							3	The intended respondent has passed on
							24	The intended respondent is institutionalized
							2	I do not wish to participate in this survey
							8	The survey is not applicable to me
							11	Breakoff
						*/
) rj on sp.SAMPLEPOP_ID = rj.SamplePop_id
and sm.STRLITHOCODE not in (select STRLITHOCODE from PhoneVendorCancelListLog)
where ms.STRMAILINGSTEP_NM like '%Phone%' and ms.INTSEQUENCE > 1 
and ms2.bitSendSurvey = 1
and getdate() < sm.datExpire
and rj.SamplePop_id is not null
and (@Vendor_Id is null or (ms.Vendor_ID = @Vendor_Id))

select Survey_id, StrLithoCode as 'Litho' from PhoneVendorCancelListLog 
where datSentToVendor is null
  and (@Vendor_Id is null or (Vendor_ID = @Vendor_Id))
order by survey_id, strlithocode

END
GO