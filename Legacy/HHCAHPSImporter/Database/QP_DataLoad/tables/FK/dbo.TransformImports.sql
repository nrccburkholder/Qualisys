ALTER TABLE dbo.TransformImports ADD CONSTRAINT
FK_TransformImports_TransformLibrary FOREIGN KEY
(
	TransformLibraryId
) 
REFERENCES dbo.TransformLibrary
(
	TransformLibraryId
)
GO

ALTER TABLE dbo.TransformImports ADD CONSTRAINT
FK_TransformImports_Transform FOREIGN KEY
(
	TransformId
) 
REFERENCES dbo.Transform
(
	TransformId
)
GO