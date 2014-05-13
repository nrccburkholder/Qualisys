IF EXISTS (SELECT * FROM DL_ErrorCodes WHERE DL_Error_ID = 17)
BEGIN
    UPDATE DL_ErrorCodes
    SET ErrorDesc = 'Results Must Exist With Disposition', DateCreated = GetDate()
    WHERE DL_Error_ID = 17
END
ELSE
BEGIN
    INSERT INTO DL_ErrorCodes(ErrorDesc, DateCreated)
    VALUES('Results Must Exist With Disposition', GetDate())
END