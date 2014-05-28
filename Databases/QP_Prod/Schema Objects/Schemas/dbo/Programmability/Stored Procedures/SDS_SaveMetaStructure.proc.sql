CREATE PROCEDURE dbo.SDS_SaveMetaStructure
@Employee_ID INT, @isKeyField BIT, @isUserField BIT, @isMatchField BIT, @isPosted BIT, @isPII BIT OUTPUT, @isAllowUS BIT OUTPUT, 
@Table_id INT, @Field_id INT OUTPUT, @LookupTable_id INT, @LookupField_id INT, @LookupType CHAR(1), @ResultMsg VARCHAR(100) OUTPUT
AS 
DECLARE @isNew BIT, @Tablename VARCHAR(20), @fldname VARCHAR(20)

SELECT @Tablename = strTable_nm FROM MetaTable WHERE Table_id=@Table_id

IF EXISTS(SELECT * FROM MetaStructure WHERE Table_id=@Table_id AND Field_id=@Field_id)
	SET @isNew=0
ELSE 
	SET @isNew=1

IF @isKeyField=1 AND @isNew=1
BEGIN
	SET @fldname = 
		CASE @Tablename 
		WHEN 'POPULATION' THEN 'pop_id' 
		WHEN 'ENCOUNTER' THEN 'enc_id' 
		WHEN 'PROVIDER' THEN 'prov_id' 
		ELSE LEFT(@Tablename + '_id', 20) 
		END
	
	IF NOT EXISTS (SELECT * FROM MetaField WHERE strField_nm=@fldname)
	BEGIN
		INSERT INTO MetaField (strField_nm, strField_dsc, strFieldDataType, bitSyskey, bitPII)
		VALUES (@fldname, 'key field for '+@Tablename, 'I', 1, 0)
	END

	SELECT @Field_id=Field_id FROM MetaField WHERE strField_nm=@fldname
END

IF @isNew=1
BEGIN
	INSERT INTO MetaStructure (Table_id, Field_id, bitKeyField_flg, bitUserField_flg, bitMatchField_flg, bitPostedField_flg, bitPII, bitAllowUS)
	VALUES (@Table_id, @Field_id, @isKeyField, @isUserField, @isMatchField, @isPosted, @isPII, @isAllowUS)
END
ELSE
BEGIN
	UPDATE 	MetaStructure
	SET 	bitKeyField_flg=@isKeyField, 
		bitUserField_flg=@isUserField, 
		bitMatchField_flg=@isMatchField, 
		bitPostedField_flg=@isPosted,
		bitPII=@isPII,
		bitAllowUS=@isAllowUS
	WHERE 	Table_id=@Table_id AND Field_id=@Field_id
END

--  delete the record from MetaLookup 
DELETE FROM MetaLookup 
WHERE numMasterTable_id=@Table_id
AND numMasterField_id=@Field_id

-- and add it back, if appropriate
IF (@LookupTable_id>0 AND @LookupField_id>0) 
BEGIN
	INSERT INTO MetaLookup (numMasterTable_id, numMasterField_id, numLkupTable_id, numLkupField_id, strLkup_type)
	VALUES (@Table_id, @Field_id, @LookupTable_id, @LookupField_id, @LookupType)
END

SET @ResultMsg='Success'


