CREATE TABLE dbo.TransformDefinition
(
	TransformId INT NOT NULL,
	TransformTargetId INT NOT NULL,
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL	
)
GO