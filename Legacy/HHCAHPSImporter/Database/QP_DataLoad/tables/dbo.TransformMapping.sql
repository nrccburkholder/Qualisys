CREATE TABLE dbo.TransformMapping
(
	TransformMappingId INT NOT NULL IDENTITY(1,1),
	TransformTargetId INT NOT NULL,
	SourceFieldName varchar(100) NULL, 
	TargetFieldname varchar(100) NOT NULL,
	Transform varchar(7000) NULL,
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL
)
GO