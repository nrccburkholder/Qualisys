CREATE PROCEDURE sp_NRCList_GetCodeList
    @Survey_id int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare variables
DECLARE @CmntSubHeader_id int

--Get the subheader id to be used for this survey
SET @CmntSubHeader_id = (SELECT CmntSubHeader_id FROM CommentSurveyCodeList WHERE Survey_id = @Survey_id)

--Get the lists to be returned
IF @CmntSubHeader_id IS NULL
BEGIN
    --The specified survey does not have an entry in CommentSurveyCodeList so return all lists
    SELECT ch.CmntHeader_id, ch.strCmntHeader_Nm, cs.CmntSubHeader_id, cs.strCmntSubHeader_Nm, 
           cc.CmntCode_id, cc.strCmntCode_Nm 
    FROM CommentHeaders ch (NOLOCK), CommentSubHeaders cs (NOLOCK), CommentCodes cc (NOLOCK)
    WHERE ch.CmntHeader_id = cs.CmntHeader_id
      AND cs.CmntSubHeader_id = cc.CmntSubHeader_id
      AND ch.bitRetired = 0
      AND cs.bitRetired = 0
      AND cc.bitRetired = 0
    ORDER BY ch.intOrder, cs.intOrder, cc.intOrder
END
ELSE
BEGIN
    --Return the specified list
    SELECT ch.CmntHeader_id, ch.strCmntHeader_Nm, cs.CmntSubHeader_id, cs.strCmntSubHeader_Nm, 
           cc.CmntCode_id, cc.strCmntCode_Nm 
    FROM CommentHeaders ch (NOLOCK), CommentSubHeaders cs (NOLOCK), CommentCodes cc (NOLOCK)
    WHERE ch.CmntHeader_id = cs.CmntHeader_id
      AND cs.CmntSubHeader_id = cc.CmntSubHeader_id
      AND ch.bitRetired = 0
      AND cs.bitRetired = 0
      AND cc.bitRetired = 0
      AND cs.CmntSubHeader_id = @CmntSubHeader_id
    ORDER BY ch.intOrder, cs.intOrder, cc.intOrder
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


