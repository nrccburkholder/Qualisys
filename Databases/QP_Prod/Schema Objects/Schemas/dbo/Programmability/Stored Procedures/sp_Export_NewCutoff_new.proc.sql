CREATE PROCEDURE sp_Export_NewCutoff_new 
 @Survey_id INTEGER, 
 @Start_dt DATETIME, 
 @Stop_dt DATETIME, 
 @Associate VARCHAR(20)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION
DECLARE @NewCutoff_id INTEGER, @strCutoffType CHAR(1), @Study_id INTEGER, @strCutoffField VARCHAR(40), @datStartProc DATETIME
SELECT @datStartProc=GETDATE()
INSERT INTO Cutoff (Survey_id,datCutoffdate,Employee_id,datCutoffStart_dt,datCutoffStop_dt)
  SELECT @Survey_id,GETDATE(),Employee_id,@Start_dt, @Stop_dt
  FROM Employee WHERE strNTLogin_nm=@Associate

SELECT @NewCutoff_id=SCOPE_IDENTITY()

SELECT @Study_id=sd.Study_id, @strCutoffType=STRCutoffRESPONSE_CD, @strCutoffField=mt.strTable_nm+mf.strField_nm
FROM Survey_def sd LEFT OUTER JOIN MetaTable mt ON CutoffTable_id=mt.Table_id 
 LEFT OUTER JOIN MetaField mf ON Cutofffield_id=mf.field_id 
WHERE Survey_id=@Survey_id
IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    RETURN -1
  END

IF @strCutoffType='0'
 BEGIN
  update qf
    set Cutoff_id=@newCutoff_id
    FROM QuestionForm qf, SamplePop sp, SampleSet ss
    WHERE qf.Survey_id=@Survey_id
      AND qf.Cutoff_id IS NULL
      AND qf.datResultsImported IS NOT NULL
      AND qf.SamplePop_id=sp.SamplePop_id
      AND sp.SampleSet_id=ss.SampleSet_id
      AND ss.datSampleCreate_dt >= @Start_dt
      AND ss.datSampleCreate_dt < DATEADD(DAY,1,@Stop_dt)
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN -1
    END
 END
ELSE IF @strCutoffType='1'
 BEGIN
  UPDATE QuestionForm
    SET Cutoff_id=@newCutoff_id
    WHERE Survey_id=@Survey_id
      AND Cutoff_id IS NULL
      AND datResultsImported >= @Start_dt 
      AND datResultsImported < DATEADD(DAY,1,@Stop_dt)
  IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RETURN -1
    END
 END
ELSE
  BEGIN
    DECLARE @PopOrEncTable_id INTEGER, @strPopOrEncField CHAR(16), @SQL VARCHAR(8000)

    SET @PopOrEncTable_id = -1
    SELECT @PopOrEncTable_id=Table_id, @strPopOrEncField = 'EncounterEnc_id'
    FROM MetaTable
    WHERE Study_id=@Study_id
      AND strTable_nm='ENCOUNTER'
    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN -1
      END
    ELSE IF ISNULL(@PopOrEncTable_id,-1) = -1
      SELECT @PopOrEncTable_id=Table_id, @strPopOrEncField = 'PopulationPop_id'
      FROM MetaTable
      WHERE Study_id=@Study_id
        AND strTable_nm='POPULATION'
    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN -1
      END

IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='ENCOUNTER')
BEGIN
    SELECT @SQL = 
    'UPDATE qf '+
      'SET Cutoff_id='+CONVERT(VARCHAR,@newCutoff_id)+' '+
      'FROM QuestionForm qf(NOLOCK), SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), '+
      's'+CONVERT(VARCHAR,@Study_id)+'.Big_View BV(NOLOCK) '+
      'WHERE qf.Survey_id='+CONVERT(VARCHAR,@Survey_id)+
      '  AND qf.Cutoff_id IS NULL'+
      '  AND qf.datResultsImported IS NOT NULL'+
      '  AND qf.SamplePop_id=sp.SamplePop_id'+
      '  AND sp.Pop_id=ss.Pop_id'+
      '  AND sp.SampleSet_id=ss.SampleSet_id'+
      '  AND ss.strUnitSelectType=''D'''+
	  '  AND ss.Enc_id=BV.EncounterEnc_id'+
      '  AND '+@strCutoffField+' between '''+CONVERT(VARCHAR,@Start_dt,100)+''' AND '''+CONVERT(VARCHAR,@Stop_dt,100)+''''
END
ELSE
BEGIN
    SELECT @SQL = 
    'UPDATE qf '+
      'SET Cutoff_id='+CONVERT(VARCHAR,@newCutoff_id)+' '+
      'FROM QuestionForm qf(NOLOCK), SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), '+
      's'+CONVERT(VARCHAR,@Study_id)+'.Big_View BV(NOLOCK) '+
      'WHERE qf.Survey_id='+CONVERT(VARCHAR,@Survey_id)+
      '  AND qf.Cutoff_id IS NULL'+
      '  AND qf.datResultsImported IS NOT NULL'+
      '  AND qf.SamplePop_id=sp.SamplePop_id'+
      '  AND sp.Pop_id=ss.Pop_id'+
      '  AND sp.SampleSet_id=ss.SampleSet_id'+
      '  AND ss.strUnitSelectType=''D'''+
	  '  AND ss.Pop_id=BV.PopulationPop_id'+
      '  AND '+@strCutoffField+' between '''+CONVERT(VARCHAR,@Start_dt,100)+''' AND '''+CONVERT(VARCHAR,@Stop_dt,100)+''''
END


    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN -1
      END
        
    EXEC (@SQL)
    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN -1
      END

  END

COMMIT TRANSACTION

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


