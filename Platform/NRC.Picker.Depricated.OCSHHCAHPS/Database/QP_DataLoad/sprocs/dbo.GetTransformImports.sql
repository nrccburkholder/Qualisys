CREATE PROC dbo.GetTransformImports( @TransformId int )
AS
BEGIN
	SELECT 
		a.TransformLibraryId,
		a.TransformLibraryName,
		a.Code
	from TransformLibrary as a with(nolock)
	inner join TransformImports as b with(nolock) on a.TransformLibraryId=b.TransformLibraryId
	where b.TransformId = @TransformId
END
GO