CREATE TABLE dbo.TransformLibrary
(
	TransformLibraryId int NOT NULL IDENTITY(1,1),
	TransformLibraryName varchar(32) NOT NULL,
	Code varchar(7000) NOT NULL,
	CreateDate DateTime NOT NULL DEFAULT(getdate()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DateTime NULL,
	UpdateUser varchar(64) NULL
)
GO