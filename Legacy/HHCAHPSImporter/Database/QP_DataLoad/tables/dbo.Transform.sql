CREATE TABLE dbo.Transform
(
	TransformId INT NOT NULL IDENTITY(1,1),
	TransformName varchar(100) NOT NULL,
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL
)
GO