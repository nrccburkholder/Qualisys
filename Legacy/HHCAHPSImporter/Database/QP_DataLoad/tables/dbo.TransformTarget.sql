CREATE TABLE dbo.TransformTarget
(
	TransformTargetId INT NOT NULL IDENTITY(1,1),
	TargetName varchar(100) NOT NULL, -- OCS HHCAHPS Encounter
	TargetTable varchar(100) NOT NULL, -- Encounter_Load
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL	
)
GO