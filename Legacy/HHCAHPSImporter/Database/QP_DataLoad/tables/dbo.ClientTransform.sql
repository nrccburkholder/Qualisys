CREATE TABLE dbo.ClientTransform
(
	Client_id int not NULL,
	Study_id int not null,
	Survey_id int not null,
	TransformId int not null,
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL	
)
GO