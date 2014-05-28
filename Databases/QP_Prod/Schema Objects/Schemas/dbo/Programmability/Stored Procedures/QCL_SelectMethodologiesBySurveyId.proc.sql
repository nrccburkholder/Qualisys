CREATE PROCEDURE dbo.QCL_SelectMethodologiesBySurveyId
@SurveyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT mm.Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
       sm.StandardMethodologyId, datCreate_dt, CASE WHEN a.Methodology_id IS NULL THEN 1 ELSE 0 END bitAllowEdit,
       bitCustom
FROM MailingMethodology mm LEFT JOIN (SELECT Methodology_id FROM ScheduledMailing
 GROUP BY Methodology_id) a
ON mm.Methodology_id=a.Methodology_id, StandardMethodology sm
WHERE Survey_id=@SurveyId
AND mm.StandardMethodologyID=sm.StandardMethodologyID
ORDER BY mm.Methodology_id


