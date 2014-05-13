CREATE PROCEDURE [dbo].[sp_InsertUpdateResponseRankOrder]
	@qstncore int,
	@val int,
	@rankOrder int,
    @strUser_nm varchar(20)
AS

SET NOCOUNT ON

IF EXISTS(SELECT [qstncore], [val] FROM [dbo].[ResponseRankOrder] WHERE [qstncore] = @qstncore AND [val] = @val)
BEGIN
	UPDATE [dbo].[ResponseRankOrder] SET
		[rankOrder] = @rankOrder
	WHERE
		[qstncore] = @qstncore
		AND [val] = @val

    INSERT lu_ResponseRankOrder_log (QstnCore, Val, RankOrder, Operation, datChange, strUser_nm) 
            values (@qstncore, @val, @rankOrder, 'U', getdate(), @strUser_nm )
END
ELSE
BEGIN
	INSERT INTO [dbo].[ResponseRankOrder] (
		[qstncore],
		[val],
		[rankOrder]
	) VALUES (
		@qstncore,
		@val,
		@rankOrder
	)

	INSERT lu_ResponseRankOrder_log (QstnCore, Val, RankOrder, Operation, datChange, strUser_nm) 
            values (@qstncore, @val, @rankOrder, 'I', getdate(), @strUser_nm )
END

