CREATE PROCEDURE [dbo].[QP_Rep_RespRateByClient]
	@Associate		VARCHAR(42),
	@Client			VARCHAR(42)
AS

DECLARE @Client_id INT

SELECT @Client_id=Client_id
FROM Client
WHERE strClient_nm=@Client

EXEC datamart.QP_Comments.dbo.RR_RespRatebyClient @Client_id


