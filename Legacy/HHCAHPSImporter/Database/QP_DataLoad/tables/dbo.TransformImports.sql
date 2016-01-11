CREATE TABLE dbo.TransformImports
(
	TransformId INT NOT NULL,
	TransformLibraryId INT NOT NULL,
	CreateDate DateTime NOT NULL DEFAULT(getdate()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DateTime NULL,
	UpdateUser varchar(64) NULL
)
GO