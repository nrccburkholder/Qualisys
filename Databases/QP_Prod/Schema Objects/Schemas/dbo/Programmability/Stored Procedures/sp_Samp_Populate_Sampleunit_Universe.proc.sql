/***********************************************************************************************************************************  
SP Name: sp_Samp_Populate_Sampleunit_Universe   
Part of:  Sampling Tool  
Purpose:    
Input:    
   
Output:    
Creation Date: 03/01/2004  
Author(s): DC  
Revision: First build - 03/01/2004  
 03/09/2006 DC -ADDed code to handle the resurveyDate field  
 05/13/2009 DRM -Changed @DataSet parm to accept 500 char
***********************************************************************************************************************************/  
CREATE PROCEDURE [dbo].[sp_Samp_Populate_Sampleunit_Universe]   
 @Study Integer,  
    @Survey Integer,  
    @DataSet VarChar(500),   
    @Pop_Enc VarChar(200),  
    @Bigview_join VarChar(200),   
    @HH_Field VarChar(200) = null  
AS  
DECLARE @strInsert VarChar(8000), @EncounterDateField varchar(42), @sql varchar(8000),  
  @EncTable bit,@sampleplan_id int, @reportdatefield varchar(42)  
  
Insert into #Timer (PostSampleStart) values (getdate())   
  
/* make sure sampleunitTreeIndex is populated*/  
Select @sampleplan_id=sampleplan_id  
from sampleplan  
where survey_id=@Survey  
  
execute SP_SAMP_AddTreeIndex @sampleplan_id  
  
  
IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study AND strTable_nm='Encounter')>0  
SELECT @EncTable=1  
ELSE   
SELECT @EncTable=0  
  
CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))  
  
SET @SQL = 'INSERT INTO #DATEFIELD' +  
   ' SELECT mt.strTable_nm + mf.strField_nm' +  
   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +  
   ' WHERE sd.Study_id = mt.Study_id' +  
   ' AND ms.Table_id = mt.Table_id' +  
   ' AND ms.Field_id = mf.Field_id' +  
   ' AND ms.table_id=sd.sampleEncountertable_id' +  
   ' AND ms.field_id=sd.sampleEncounterfield_id' +  
   ' AND mf.strFieldDataType = ''D''' +  
   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey)  
  
Execute (@sql)  
  
SELECT @EncounterDateField=DATEFIELD  
FROM #DATEFIELD  
  
truncate table #DateField  
SET @SQL = 'INSERT INTO #DATEFIELD' +  
   ' SELECT mt.strTable_nm + mf.strField_nm' +  
   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +  
   ' WHERE sd.Study_id = mt.Study_id' +  
   ' AND ms.Table_id = mt.Table_id' +  
   ' AND ms.Field_id = mf.Field_id' +  
   ' AND ms.table_id=sd.cutofftable_id' +  
   ' AND ms.field_id=sd.cutofffield_id' +  
   ' AND mf.strFieldDataType = ''D''' +  
   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@Survey)  
  
Execute (@sql)  
  
SELECT @reportdatefield=DATEFIELD  
FROM #DATEFIELD  
  
DROP TABLE #DATEFIELD  
  
  
SET @strInsert = 'INSERT INTO #SampleUnit_Universe   
SELECT DISTINCT SampleUnit_id, ' +  
@Pop_Enc + ', '   
  
IF @HH_Field is not null SET @strInsert = @strInsert + @HH_Field + ', '  
  
SET @strInsert = @strInsert + ' POPULATIONAge, DQ_ID, '+  
'Case When DQ_ID > 0 THEN 4 ELSE 0 END, ''N'', ' +  
     case   
  when @EncounterDateField is not null then @EncounterDateField  
  else 'null'  
  end + ', Null, ' +  
  case   
  when @reportDateField is not null then @reportDateField  
  else 'null'  
  end +  
' FROM #PreSample X, S' +CONVERT(VARCHAR,@Study)+ '.Big_View BV ' +  
'WHERE ' + @Bigview_join   
  
Set @strInsert=@strInsert + ' ORDER BY SampleUnit_id, ' + @Pop_Enc   
  
EXECUTE (@strInsert)  
  
EXECUTE dbo.sp_Samp_IdentifyDataSets @DataSet


