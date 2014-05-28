CREATE PROCEDURE SP_DBM_stripRTF @Survey_id INT
AS

--Create the temp work table
CREATE TABLE #RTF (
	RTF_ID			INT IDENTITY(1,1),
	strRichText		TEXT,
	strPlainText		VARCHAR(8000),
	SelQstns_id		INT,
	Survey_id		INT
)

--Get the records we need to update.  I am only concerned with English versions that are not a part
-- of the address subsection.
INSERT INTO #RTF (strRichText, SelQstns_id, Survey_id)
SELECT RichText, SelQstns_id, Survey_id
FROM Sel_Qstns
WHERE Survey_id = @Survey_id
AND Section_id > -1
AND RichText IS NOT NULL
AND Language = 1
AND strFullQuestion IS NULL

IF @@ERROR <> 0
BEGIN
	RETURN
END

DECLARE @ID INT, @RTF VARCHAR(8000), @begin INT, @end INT, @code INT

SET NOCOUNT ON

--Loop thru to strip out the richtext
SELECT TOP 1 @ID = RTF_ID, @RTF = strRichText FROM #RTF WHERE strPlainText IS NULL
WHILE @@Rowcount > 0 
BEGIN

  SET @RTF = REPLACE(@RTF, CHAR(0), '')
  SET @RTF = LTRIM(RTRIM(@RTF))

  -- the whole RTF stream is imbeded between a { and }, so if the first character isn't '{' then it must not be rich text
  IF LEFT(@RTF, 1) = '{'
  BEGIN
    -- change code delimiters { and } to CHAR(1) & CHAR(2).  Insure there is a space before opening braces
    SET @RTF = REPLACE(@RTF, ' \{', ' ' + CHAR(1))
    SET @RTF = REPLACE(@RTF, '\{', ' ' + CHAR(1))
    SET @RTF = REPLACE(@RTF, '\}', CHAR(2))

    -- change any literal slashes to CHAR(3)
    SET @RTF = REPLACE(@RTF, '\\', CHAR(3))

    -- change any CRLF to CHAR(4)
    SET @RTF = REPLACE(@RTF, CHAR(13) + CHAR(10), ' ' + CHAR(4))  -- a space is added before the CRLF so that the CRLF is 
							  	  -- recognized as white-space when we later delete text 
								  -- between a \ and a space

    -- we remove first brace since we don't want to delete everything
    SET @RTF = SUBSTRING(@RTF, 2, LEN(@RTF) - 1)

    -- remove everything within sets of braces
    DECLARE @StartIndex INT
    WHILE CHARINDEX('{', @RTF) > 0
    BEGIN
      SET @StartIndex = CHARINDEX('{', @RTF) + 1
      -- find the last '{' before the first '}' so we properly identify nested braces  ...{...{...}{...}.}
      WHILE CHARINDEX('{', @RTF + '{', @StartIndex) < CHARINDEX('}', @RTF)
        SET @StartIndex = CHARINDEX('{', @RTF, @StartIndex) + 1
      SET @RTF = STUFF(@RTF, @StartIndex - 1, 2 + CHARINDEX('}', @RTF) - @StartIndex, '')
    END

    -- only the last brace should now exist, so remove it
    SET @RTF = REPLACE(@RTF, '}', '')

    -- remove anything between a slash and a space
    WHILE CHARINDEX('\', @RTF) > 0
    BEGIN
      SET @StartIndex = CHARINDEX('\', @RTF)
      SET @RTF = STUFF(@RTF, @StartIndex, 1 + CHARINDEX(' ', @RTF, @StartIndex) - @StartIndex, '')
    END

    -- change special characters back to what they're supposed to be
    SET @RTF = REPLACE(@RTF, CHAR(1), '{')
    SET @RTF = REPLACE(@RTF, CHAR(2), '}')
    SET @RTF = REPLACE(@RTF, CHAR(3), '\')
    SET @RTF = REPLACE(@RTF, ' ' + CHAR(4), CHAR(4))

    -- remove any CRLFs from the beginning and end 
    WHILE LEFT(@RTF, 1) = CHAR(4)
      SET @RTF = RIGHT(@RTF, LEN(@RTF) - 1)
    WHILE RIGHT(@RTF, 1) = CHAR(4)
      SET @RTF = LEFT(@RTF, LEN(@RTF) - 1)

    -- change CHAR(4) back to CRLF.  
    SET @RTF = REPLACE(@RTF, CHAR(4), CHAR(13) + CHAR(10))

    -- if you'd rather represent CRLF's as an HTML '<BR>' tag, you could use this instead of the previous SET command:
    -- SET @RTF = REPLACE(@RTF, CHAR(4), '<BR>')


  END

  UPDATE #RTF SET strPlaintext = @RTF WHERE RTF_ID = @ID

  IF @@ERROR <> 0
  BEGIN
	RETURN
  END

  SELECT TOP 1 @ID = RTF_ID, @RTF = strRichText FROM #RTF WHERE strPlainText IS NULL

END

SELECT @ID = MAX(RTF_id) FROM #RTF

--Now to loop thru and replace the codes
WHILE @ID > 0
BEGIN

    SELECT @RTF = strPlainText FROM #RTF WHERE RTF_id = @ID

    --Check to see if the field contains a code.
    WHILE PATINDEX('%{%',@RTF) > 0
    BEGIN
	-- Get the beginning and end of the code
	SELECT @begin = PATINDEX('%{%',@RTF), @end = PATINDEX('%}%',@RTF)
	-- Pull out the code value
	SET @code = SUBSTRING(@RTF,(@begin+1),(@end-@begin-1))
	-- Put the generic value for the code into the string instead of the code number
	SET @RTF = LEFT(@RTF,(@begin-1))+dbo.TagDesc(@code)+SUBSTRING(@RTF,(@end+1),8000)
    END

    --Replacing the tick with the single quote.
    SET @RTF = REPLACE(@RTF,'`','''')

    UPDATE #RTF SET strPlainText = @RTF WHERE RTF_id = @ID

    SET @ID = @ID - 1

END

SET NOCOUNT OFF

--Now to update Sel_Qstns
UPDATE sq
SET sq.strFullQuestion = t.strPlainText
FROM Sel_Qstns sq, #RTF t
WHERE sq.Survey_id = t.Survey_id
AND sq.SelQstns_id = t.SelQstns_id
AND sq.Language = 1

--Clean up
DROP TABLE #RTF


