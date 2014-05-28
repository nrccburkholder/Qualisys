CREATE PROCEDURE SP_QUEUE_Clear_PCL_Tables_TP
AS

/*
	Create 1/23/04 SS (Adapted From SP_QUEUE_Clear_PCL_Tables for TestPrints
*/

SELECT DISTINCT survey_id
INTO #survey
FROM pclneeded_TP

DELETE p
FROM pcl_logo_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_scls_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_skip_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_pcl_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_cover_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_textbox_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL

DELETE p
FROM pcl_qstns_TP p LEFT OUTER JOIN #survey s
ON p.survey_id = s.survey_id
WHERE s.survey_id IS NULL


