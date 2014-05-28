CREATE PROCEDURE dbo.SDS_SaveMetaTable
@Employee_ID INT, @Table_id INT OUTPUT, @Study_id INT, @Table_nm VARCHAR(20), @Table_dsc VARCHAR(80), @usesAddress BIT
AS

IF EXISTS(SELECT * FROM MetaTable WHERE Table_id=@Table_id)
BEGIN
	UPDATE MetaTable
	SET Study_id=@Study_id, strTable_nm=RTRIM(@Table_nm), strTable_dsc=@Table_dsc, bitUsesAddress=@usesAddress
	WHERE Table_id=@Table_id
END
ELSE
BEGIN
	INSERT INTO MetaTable (Study_id, strTable_nm, strTable_dsc, bitUsesAddress)
	VALUES (@Study_id, RTRIM(@Table_nm), @Table_dsc, @usesAddress)

	SELECT @Table_id=Table_id 
	FROM MetaTable 
	WHERE Study_id=@Study_id AND strTable_nm=RTRIM(@Table_nm)
END


