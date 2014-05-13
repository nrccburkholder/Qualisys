set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].SV_SurveyProperties
@Survey_id INT
AS

CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))

IF NOT EXISTS(SELECT * FROM survey_def WHERE Survey_id=@Survey_id AND cutofftable_id=SampleEncounterTable_id and cutofffield_id=SampleEncounterField_id)
INSERT INTO #M (Error, strMessage)
SELECT 2 Error,'Sample Encounter Date Field and Report Date Field are different.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0 Error,'Sample Encounter Date Field and Report Date Field are the same.'

SELECT * FROM #M

DROP TABLE #M



