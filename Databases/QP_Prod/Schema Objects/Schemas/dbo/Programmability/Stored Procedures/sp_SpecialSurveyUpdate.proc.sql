CREATE PROCEDURE [dbo].[sp_SpecialSurveyUpdate]
    @StudyID     INT,
    @SamplePopID INT,
	@FieldName   varchar(42),
	@FieldValue  varchar(100)

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @PopID       INT
DECLARE @DataType    CHAR(1)
DECLARE @StringValue VARCHAR(102)
DECLARE @Sql         VARCHAR(8000)

--Make sure the specified field exists
SELECT @DataType = mf.strFieldDataType
FROM MetaField mf, MetaTable mt, MetaStructure ms
WHERE mf.Field_id = ms.Field_id
  AND ms.Table_id = mt.Table_id
  AND ms.bitPostedField_Flg = 1
  AND mt.strTable_Nm = 'POPULATION'
  AND mf.strField_Nm = @FieldName
  AND mt.Study_id = @StudyID

IF @DataType IS NOT NULL
BEGIN
    --Set the field value for the SQL
    IF @DataType = 'I'
	    SET @StringValue = @FieldValue
    ELSE
	    SET @StringValue = '''' + @FieldValue + ''''

    --Get the PopID
    SELECT @PopID = Pop_ID FROM SamplePop WHERE SamplePop_ID = @SamplePopID

    --Update the Population table for this study
    SET @Sql='UPDATE s' + CONVERT(VARCHAR, @StudyID) + '.Population ' + 
             'SET ' + @FieldName + ' = ' + @StringValue + ' ' +
             'WHERE Pop_id = ' + CONVERT(VARCHAR, @PopID)
    EXEC (@Sql)

		
	--insert into Catalyst extract queue so field(s) will be updated
	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, source)  
	select distinct 7, @SamplePopID, NULL, 0, 'sp_SpecialSurveyUpdate'  

END



--Cleanup
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


