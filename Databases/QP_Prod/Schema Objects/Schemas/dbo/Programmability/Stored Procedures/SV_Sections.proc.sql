CREATE PROCEDURE [dbo].[SV_Sections]
@Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced @Survey_id into SampleUnitSection where clause, and changed errors to warnings (1 to 2),
				and introduced into SampleUnitSection where clause criteria to prevent warning about phone section if
				no phone maling step is present, and about mail sections if no 1st survey mailing step is present;
				ignoring dummy question sections also
*/

SELECT 2 bitError, 'Section ' + convert(varchar,Section_ID)+' (' + Replace(Label,' ','') + ') NOT mapped to a Sample Unit' strMessage
FROM Sel_Qstns SQ
Where SQ.Survey_id=@Survey_id
AND  SQ.Subtype=3
AND  SQ.LABEL not like '%dummy%'
AND  NOT EXISTS
(SELECT * FROM SampleUnitSection SUS
WHERE SUS.SelQstnsSection = SQ.Section_ID
AND SUS.SELQSTNSSURVEY_ID=@Survey_id)
AND (SQ.LABEL not like '%phone%' OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
									where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
AND (SQ.LABEL not like '%mail%' OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
									where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
GROUP BY Section_ID, Label
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Sections validation' strMessage
