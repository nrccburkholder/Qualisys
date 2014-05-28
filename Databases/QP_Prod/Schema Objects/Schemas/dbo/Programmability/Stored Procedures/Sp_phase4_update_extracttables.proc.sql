-- Prep question results (bubble) and comments for extraction to datamart 
-- modified DBG 2/26/13 - added references to MedusaEtlFilterStudy and MedusaEtlFilterDate
CREATE PROCEDURE Sp_phase4_update_extracttables 
AS 
    -- Set study ID for new questionform_extract records (see tr_questionform_extract)  
    -- and for new comments_extract records (see tr_comments) 
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'MedusaEtlFilterStudy' AND type = 'U' AND schema_id = 1) 
      CREATE TABLE dbo.MedusaEtlFilterStudy ( study_id INT ) 

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'MedusaEtlFilterDate' AND type = 'U' AND schema_id = 1) 
      CREATE TABLE dbo.MedusaEtlFilterDate ( beginDate DATETIME, endDate DATETIME ) 
      
    -- if filtering the ETL for specific dates, there'll be a record in MedusaEtlFilterDate
    -- use that record to set @filterBeginDate and @filterEndDate
    DECLARE @filterBeginDate DATETIME, @filterEndDate DATETIME

    SELECT @filterBeginDate = begindate, @filterEndDate = enddate 
    FROM   MedusaEtlFilterDate 

    -- if not filtering, set @filterBeginDate and @filterEndDate to a sufficently wide range.
    IF @filterBeginDate IS NULL SET @filterBeginDate = '1/1/1900' 
    IF @filterEndDate IS NULL SET @filterEndDate = '12/31/2100' 

    -- if filtering the ETL for specific studies, there'll be records in MedusaEtlFilterStudy
    IF EXISTS (SELECT * FROM MedusaEtlFilterStudy) 
    BEGIN
      -- there are records in MedusaEtlFilterStudy, so add it into the queries
      UPDATE e 
      SET    e.study_id = sd.study_id 
      FROM   questionform_extract e, 
             questionform qf, 
             survey_def sd, 
             MedusaEtlFilterStudy sf 
      WHERE  e.study_id IS NULL 
             AND e.questionform_id = qf.questionform_id 
             AND qf.survey_id = sd.survey_id 
             AND sd.study_id = sf.study_id 
             AND qf.datreturned BETWEEN @filterBeginDate AND @filterEndDate 

      UPDATE e
      SET    e.study_id = sd.study_id
      FROM   comments_extract e,
             comments c,
             questionform qf,
             survey_def sd, 
             MedusaEtlFilterStudy sf 
      WHERE  e.study_id IS NULL
             AND e.cmnt_id = c.cmnt_id
             AND c.questionform_id = qf.questionform_id
             AND qf.survey_id = sd.survey_id
             AND sd.study_id = sf.study_id 
             AND qf.datreturned BETWEEN @filterBeginDate AND @filterEndDate 
    END
    ELSE 
    BEGIN
      -- there are no records in MedusaEtlFilterStudy, so process all studies.
      UPDATE e 
      SET    e.study_id = sd.study_id 
      FROM   questionform_extract e, 
             questionform qf, 
             survey_def sd 
      WHERE  e.study_id IS NULL 
             AND e.questionform_id = qf.questionform_id 
             AND qf.survey_id = sd.survey_id 
             AND qf.datreturned BETWEEN @filterBeginDate AND @filterEndDate 

      UPDATE e
      SET    e.study_id = sd.study_id
      FROM   comments_extract e,
             comments c,
             questionform qf,
             survey_def sd
      WHERE  e.study_id IS NULL
             AND e.cmnt_id = c.cmnt_id
             AND c.questionform_id = qf.questionform_id
             AND qf.survey_id = sd.survey_id
             AND qf.datreturned BETWEEN @filterBeginDate AND @filterEndDate 
    END


