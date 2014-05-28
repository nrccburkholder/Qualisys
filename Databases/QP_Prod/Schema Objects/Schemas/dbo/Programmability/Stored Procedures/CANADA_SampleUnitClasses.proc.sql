CREATE PROCEDURE CANADA_SampleUnitClasses @client VARCHAR(40), @study VARCHAR(10), @survey VARCHAR(10), @associate VARCHAR(20)
AS

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'DBO' AND TABLE_NAME = 'CANADA_SAMPLEUNITCLASSES_Data')
	DROP TABLE CANADA_SAMPLEUNITCLASSES_Data

-- Testing Variables
-- 	DECLARE @client VARCHAR(40), @study VARCHAR(10), @survey VARCHAR(10), @associate VARCHAR(20)
-- 		--SELECT @client = 'Veterans Health Administration', @study = 'OP', @survey = '7733OP', @associate = 'sspicka'
-- 	SELECT @client = '_ALL_CAN'/*'CCAC'*//*'Ontario Hospital Association'*/, @study = '_ALL', @survey = '_ALL', @associate = 'sspicka'

-- Created 5/26/05 SS - Dashboard proc/report that calls procedure that populates the sampleunitclasses sit - "Show All Units" page.
-- Modified 6/2/05 SS - Added the "ALL" capability to the survey and study levels of menu selection (Looping)

-- Create holding table
	CREATE TABLE  #sampleunitclasses (Sampleunit_id INT, strSampleUnit_nm VARCHAR(100), datLastUpdated DATETIME, intTier INT, intTreeOrder INT, SUFacility_id INT, strFacility_nm VARCHAR(100))

	DECLARE @clist VARCHAR(8000), @sql VARCHAR(8000)
	SET @clist = ''
	SET @sql = ''

	SELECT @clist = @clist + col FROM (
	SELECT TOP 100 PERCENT 
	CASE WHEN s.strService_nm = 'Other' 
		THEN LTRIM('[' + ISNULL(ps.strService_nm + '-','') + RTRIM(s.strService_nm) + '(' + LTRIM(CONVERT(VARCHAR(3),s.service_id)) + ')] VARCHAR(100),') 
		ELSE LTRIM('[' + ISNULL(ps.strService_nm + '-','') + RTRIM(s.strService_nm) + '(' + LTRIM(CONVERT(VARCHAR(3),s.service_id)) + ')] INT,') 
		END AS col
	FROM SERVICE S LEFT JOIN
	(SELECT * FROM service WHERE parentservice_id IS NULL) PS ON s.parentservice_id = ps.service_id
	ORDER BY ISNULL(ps.strService_nm + '-','') + RTRIM(s.strService_nm) + '(' + LTRIM(CONVERT(VARCHAR(3),s.service_id)) + ')'
	) sublist

-- Formatt the create dsql by dropping last comma
	SET @clist = LEFT(@clist,len(@clist)-1)

-- Alter the temp table by adding all sampleunitclass defs as columns
	SET @sql = 'ALTER TABLE #sampleunitclasses ADD ' + @clist
	EXEC (@sql)

-- Find all surveys to work on
	CREATE TABLE #worklist (survey_id INT)

	IF @client = '_ALL_CAN'
		INSERT INTO #worklist SELECT sd.survey_id FROM Client c, Study s, Survey_Def sd WHERE c.client_id = s.client_id and s.study_id = sd.study_id
			AND c.client_id in (1033,1056,1060,1062,1069,1071,1072,1076,1077,1081,1085,1090,
			1091,1092,1109,1110,1147,1154,1157,1159,1161,1162,1163,1166,1173,1174,
			1175,1177,1179,1182,1184,1185,1186,1187,1189,1190,1191,1205,1206)
	ELSE IF @study = '_ALL'
		INSERT INTO #worklist SELECT sd.survey_id FROM Client c, Study s, Survey_Def sd WHERE c.strclient_nm = @client and c.client_id = s.client_id and s.study_id = sd.study_id
	ELSE IF @survey = '_ALL'
		INSERT INTO #worklist SELECT sd.survey_id FROM Client c, Study s, Survey_Def sd WHERE c.strclient_nm = @client and s.strstudy_nm = @study and c.client_id = s.client_id and s.study_id = sd.study_id
	ELSE 
		INSERT INTO #worklist SELECT sd.survey_id FROM Client c, Study s, Survey_Def sd WHERE c.strclient_nm = @client and s.strstudy_nm = @study and sd.strsurvey_nm = @survey and c.client_id = s.client_id and s.study_id = sd.study_id

-- Now process the survey list
DECLARE @survey_id INT

WHILE (SELECT COUNT(*) FROM #worklist) > 0
	BEGIN
		SELECT TOP 1 @survey_id = survey_id FROM #worklist order by survey_id
			INSERT INTO #sampleunitclasses 
			EXEC dbo.SP_NORMS_CurrentValues @survey_id
		DELETE FROM #worklist WHERE @survey_id = survey_id 
	END

-- Add in the client study survey information for display
SELECT C.STRCLIENT_NM, C.CLIENT_ID, S.STRSTUDY_NM, S.STUDY_ID, SD.STRSURVEY_NM, SD.SURVEY_ID, SUC.*
INTO CANADA_SAMPLEUNITCLASSES_Data
FROM #SAMPLEUNITCLASSES SUC, CLIENT C, STUDY S, SURVEY_DEF SD, SAMPLEUNIT SU, SAMPLEPLAN SP WHERE SUC.SAMPLEUNIT_iD = SU.SAMPLEUNIT_ID AND SU.SAMPLEPLAN_ID = SP.SAMPLEPLAN_ID AND SP.SURVEY_ID = SD.SURVEY_ID AND SD.STUDY_ID = S.STUDY_ID AND S.CLIENT_ID = C.CLIENT_ID

-- Clean up
DROP TABLE #worklist
DROP TABLE #sampleunitclasses
/******************************************/


