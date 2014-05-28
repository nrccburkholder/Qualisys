CREATE PROCEDURE QP_Rep_VALithoDatabase_RN  
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @SampleSet VARCHAR(50),
 @MailingStep VARCHAR(20)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @intSurvey_id INT, @intSampleSet_id INT, @intMailingStep_id INT
DECLARE @strSql VARCHAR(8000), @intStudy INT, @Field VARCHAR(42), @PopField VARCHAR(42)

SELECT @intSurvey_id=sd.survey_id, @intStudy = s.study_id
FROM survey_def sd, study s, client c
WHERE c.strclient_nm=@Client
  AND s.strstudy_nm=@Study
  AND sd.strsurvey_nm=@survey
  AND c.client_id=s.client_id
  AND s.study_id=sd.study_id

SELECT @intSampleSet_id=SampleSet_id
FROM SampleSet
WHERE Survey_id=@intSurvey_id
  AND ABS(DATEDIFF(SECOND,datSampleCreate_Dt,CONVERT(DATETIME,@SampleSet)))<=1

SELECT  MailingStep_id
into #MailingSteps
FROM mailingstep 
WHERE survey_id = @intsurvey_id
AND strmailingstep_nm = @MailingStep
 
SELECT strfield_nm popfield, STRFIELDSHORT_NM as strfield_nm, strfielddatatype, intfieldlength, null updated 
into #field
FROM metadata_view
WHERE strtable_nm = 'population'
AND study_id = @intstudy

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'bd_va_population') 
DROP TABLE bd_va_population

SET @strsql = 'CREATE TABLE bd_va_population (litho INT'

WHILE (SELECT count(*) FROM #field WHERE updated IS NULL) > 0
BEGIN

SET @field = (SELECT top 1 strfield_nm FROM #field WHERE updated IS NULL)

IF (SELECT strfielddatatype FROM #field WHERE strfield_nm = @field) = 'S'

SET @strsql = @strsql + ', ' + @field + ' VARCHAR(' + (SELECT CONVERT(VARCHAR,intfieldlength) FROM #field WHERE strfield_nm = @field) + ')'

IF (SELECT strfielddatatype FROM #field WHERE strfield_nm = @field) = 'I'

SET @strsql = @strsql + ', ' + @field + ' INT'

IF (SELECT strfielddatatype FROM #field WHERE strfield_nm = @field) = 'D'

SET @strsql = @strsql + ', ' + @field + ' DATETIME'

UPDATE #field SET updated = 1 WHERE strfield_nm = @field

END

SET @strsql = @strsql + ')'

Exec (@strsql)

TRUNCATE TABLE bd_va_population

INSERT INTO bd_va_population (litho, pop_id)
SELECT strlithocode, pop_id
FROM sentmailing sm, scheduledmailing schm, samplepop sp, #mailingSteps ms
WHERE sp.sampleset_id = @intsampleset_id
AND sp.samplepop_id = schm.samplepop_id
AND schm.sentmail_id = sm.sentmail_id
AND schm.mailingstep_id = ms.MailingStep_id

SET @strsql = 'UPDATE v SET litho = litho'

WHILE (SELECT count(*) FROM #field) > 0
BEGIN 

SET @field = (SELECT TOP 1 strfield_nm FROM #field)

SET @popfield = (SELECT popfield FROM #field WHERE strfield_nm = @field)

SET @strsql = @strsql + ', v.' + @field + '=p.'+@popfield

DELETE #field WHERE strfield_nm = @field

END

SET @strsql = @strsql + ' FROM s' + CONVERT(VARCHAR,@intstudy) + '.population p, bd_va_population v WHERE v.pop_id = p.pop_id'

EXEC (@strsql)

SELECT * FROM bd_va_population

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


