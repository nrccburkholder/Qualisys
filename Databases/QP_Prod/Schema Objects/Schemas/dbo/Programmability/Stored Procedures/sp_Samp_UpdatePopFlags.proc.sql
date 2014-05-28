/****** Object:  Stored Procedure dbo.sp_Samp_UpdatePopFlags    Script Date: 9/28/99 2:57:19 PM ******/
CREATE PROCEDURE sp_Samp_UpdatePopFlags
 @intStudy_id int,
 @vcBigView_Join varchar(8000),
 @vcMinorException_Where varchar(8000)=NULL
AS
 DECLARE @vcSQL varchar(8000)
 DECLARE @vcStudy_id varchar(9)
 DECLARE @vcGenderField varchar(255)
 DECLARE @vcDocField varchar(255)
 DECLARE @intProviderTable_id int
 /*Convert the Study_id into a varchar*/
 SET @vcStudy_id = CONVERT(varchar, @intStudy_id)
 /*Fetch the Gender field*/
 SELECT @vcGenderField = strField_nm
  FROM dbo.QualPro_Params QPP, dbo.metaField MF
  WHERE QPP.numParam_Value = MF.intSpecialField_cd
   AND strParam_nm = 'FieldGender'
 /*Fetch the Provider Table ID and the Doctor Flag Field*/
 SELECT @vcDocField = strField_nm, @intProviderTable_id = MT.Table_id
  FROM dbo.QualPro_Params QPP, dbo.metaStructure MS, dbo.metaTable MT, dbo.metaField MF
  WHERE MS.Table_id = MT.Table_id
   AND MS.Field_id = MF.Field_id
   AND MF.intSpecialField_cd = QPP.numParam_Value 
   AND QPP.strParam_nm = 'FieldDoctorGroupFlag'
   AND MT.Study_id = @intStudy_id
 /*Crete the Minor Table*/
 CREATE TABLE #Minor
  (Pop_id int, bitMinor bit) 
 BEGIN TRANSACTION
 /*Remove from PopFlags the people currently in SampleUnit_Universe*/
 set @vcSQL = 'DELETE 
   FROM PF
    FROM S' + @vcStudy_id + '.PopFlags PF, #SampleUnit_Universe SUU
    WHERE SUU.Pop_id = PF.Pop_id
     AND SUU.Removed_Rule = 0
     AND SUU.strUnitSelectType <> "N"'
 EXECUTE(@vcSQL)
 IF @@error <> 0 
 BEGIN
  ROLLBACK TRANSACTION
  RETURN
 END
 /*Add the Records to PopFlags*/
 SET @vcSQL = 'INSERT INTO S' + @vcStudy_id + '.PopFlags
   SELECT DISTINCT SUU.Pop_id, "A", P.' + @vcGenderField + ', "G"
   FROM #SampleUnit_Universe SUU, S' + @vcStudy_id + '.Population P
   WHERE SUU.Pop_id = P.Pop_id
    AND SUU.Removed_Rule = 0
    AND SUU.strUnitSelectType <> "N"'
 EXECUTE (@vcSQL)
 IF @@error <> 0 
 BEGIN
  ROLLBACK TRANSACTION
  RETURN
 END
 /*Identify those people who are Minors*/
 INSERT INTO #Minor
  SELECT DISTINCT Pop_id, 1
  FROM #SampleUnit_Universe
  WHERE Age < 18
 
 IF @@error <> 0 
 BEGIN
  ROLLBACK TRANSACTION
  RETURN
 END
 /*Apply the Minor Exception Rule*/
 IF @vcMinorException_Where IS NOT NULL 
 BEGIN
  SET @vcMinorException_Where = ' AND ' + @vcMinorException_Where
  SET @vcSQL = 'UPDATE #Minor
    SET bitMinor = 0
    FROM #SampleUnit_Universe X, S' + @vcStudy_id + '.Big_View BV
    WHERE #Minor.Pop_id = X.Pop_id
     AND ' + @vcBigView_Join +
     @vcMinorException_Where
  EXECUTE (@vcSQL)
 
  IF @@error <> 0 
  BEGIN
   ROLLBACK TRANSACTION
   RETURN
  END
 END
 /*Update the Minors in PopFlags*/
 SET @vcSQL = 'UPDATE PF
   SET PF.Adult = "M" 
   FROM #Minor M, S' + @vcStudy_id + '.PopFlags PF
   WHERE PF.Pop_id = M.Pop_id
    AND M.bitMinor = 1'
 EXECUTE (@vcSQL)
 IF @@error <> 0 
 BEGIN
  ROLLBACK TRANSACTION
  RETURN
 END
 IF @intProviderTable_id IS NOT NULL
 BEGIN
  SET @vcSQL = 'UPDATE PF
    SET PF.Doc = P.' + @vcDocField  + '
    FROM S' + @vcStudy_id + '.PopFlags PF, S' + @vcStudy_id + '.Unikeys U, S' + @vcStudy_id + '.Provider P, #SampleUnit_Universe SUU
    WHERE SUU.Pop_id = PF.Pop_id
     AND PF.Pop_id = U.Pop_id
     AND U.KeyValue = P.Prov_id
     AND U.Table_id = ' + CONVERT(varchar, @intProviderTable_id) + '
     AND SUU.Removed_Rule = 0'
  EXECUTE (@vcSQL)
 
  IF @@error <> 0 
  BEGIN
   ROLLBACK TRANSACTION
   RETURN
  END
 END
 COMMIT TRANSACTION
 /*Clean up Temp Tables*/
 DROP TABLE #Minor


