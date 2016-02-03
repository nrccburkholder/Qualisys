-- DROP TABLE dbo.ClientDetail
CREATE TABLE [dbo].[ClientDetail](
	[Client_id] [int] NOT NULL,
	[ClientName] [varchar](100) NULL,
	[ExternalId] [varchar](32) NULL,
	[Study_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[Languages] [varchar](32) NULL
	)
GO
ALTER TABLE dbo.ClientDetail ADD CONSTRAINT PK_ClientDetail PRIMARY KEY CLUSTERED 
(
	Client_id,
	Study_id,
	Survey_id
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/*
select * from clientdetail where Client_id in (2048, 2198)
DELETE FROM ClientDetail where Client_id = 2048 and Languages is null
DELETE FROM ClientDetail where Client_id = 2198 and Languages = 'E'
*/


--select * into ##aatemp1 from dbo.ClientDetail
--select client_id, study_id, survey_id, COUNT(*)  from ##aatemp1 group by client_id, study_id, survey_id having COUNT(*) > 1

-- DROP TABLE dbo.Transform
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
ALTER TABLE dbo.Transform ADD CONSTRAINT [PK_Transform] PRIMARY KEY CLUSTERED
(
		TransformId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
go
INSERT INTO dbo.Transform (TransformName, CreateUser) VALUES('OCS HHCAPHS', 'nrc\aaliabadi')
GO

-- DROP TABLE dbo.TransformTarget
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
ALTER TABLE dbo.TransformTarget ADD CONSTRAINT [PK_TransformTarget] PRIMARY KEY CLUSTERED
(
		TransformTargetId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/*
INSERT INTO dbo.TransformTarget(TargetName,TargetTable,CreateUser) VALUES('OCS HHCAHPS Encounter', 'Encounter_Load', 'nrc\aaliabadi')
INSERT INTO dbo.TransformTarget(TargetName,TargetTable,CreateUser) VALUES('OCS HHCAHPS Population', 'Population_Load', 'nrc\aaliabadi')
*/
GO

-- DROP TABLE dbo.TransformDefinition
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
ALTER TABLE dbo.TransformDefinition ADD CONSTRAINT [PK_TransformDefinition] PRIMARY KEY CLUSTERED
(
		TransformId ASC,
		TransformTargetId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- INSERT INTO dbo.TransformDefinition select TransformId,TransformTargetId,getdate(),'nrc\aaliabadi',null,null from dbo.Transform as a, dbo.TransformTarget as b
GO


-- DROP TABLE dbo.ClientTransform
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
ALTER TABLE dbo.ClientTransform ADD CONSTRAINT PK_ClientTransform PRIMARY KEY CLUSTERED
(
		[Client_id] ASC,
		[Study_id] ASC,
		[Survey_id] ASC,
		[TransformId] ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/*
INSERT INTO ClientTransform SELECT Client_id,Study_id,Survey_id,1,getdate(),'nrc\aaliabadi',null,null from ClientDetail
*/

-- DROP TABLE dbo.TransformMapping
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
ALTER TABLE dbo.TransformMapping ADD CONSTRAINT [PK_TransformMapping] PRIMARY KEY CLUSTERED
(
	TransformMappingId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- DROP TABLE dbo.TransformClientMapping
CREATE TABLE dbo.TransformClientMapping
(
	Client_id int not NULL,
	Study_id int not null,
	Survey_id int not null,
	TransformMappingId int NOT NULL,
	SourceFieldName varchar(100) NULL, 
	Transform varchar(7000) NULL,
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateUser varchar(64) NOT NULL,
	UpdateDate DATETIME NULL, 
	UpdateUser varchar(64) NULL	
)
GO
ALTER TABLE dbo.TransformClientMapping ADD CONSTRAINT [PK_TransformClientMapping] PRIMARY KEY CLUSTERED
(
	Client_id asc,
	Study_id asc,
	Survey_id asc,
	TransformMappingId asc
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


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
ALTER TABLE dbo.TransformLibrary ADD CONSTRAINT [PK_TransformLibrary] PRIMARY KEY CLUSTERED
(
	TransformLibraryId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

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
ALTER TABLE dbo.TransformImports ADD CONSTRAINT [PK_TransformImports] PRIMARY KEY CLUSTERED
(
	TransformId ASC,
	TransformLibraryId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE PROC dbo.GetTransforms @Client_id int, @Study_id int, @Survey_id int
AS
BEGIN		
	SELECT 
		c.Client_id as Client_id, 
		c.Study_id as Study_id, 
		c.Survey_id as Survey_id,
		c.Languages as Languages,
		t.TransformId as TransformId,
		t.TransformName as TransformName,
		tt.TransformTargetId as TransformTargetId,
		tt.TargetName as TransformTargetName,
		tt.TargetTable as TransformTargetTable,
		COALESCE(tcm.SourcefieldName, tm.SourceFieldName) as SourceFieldName,		
		tm.TargetFieldName as TargetFieldName,		
		COALESCE(tcm.Transform, tm.Transform) as transform
	FROM 
		dbo.ClientDetail as c with(nolock)
		INNER JOIN dbo.ClientTransform as ct with(nolock) on c.Client_id=ct.Client_id and c.Study_id=ct.Study_id and c.Survey_id=ct.Survey_id
		INNER JOIN dbo.Transform as t with(nolock) on ct.TransformId = t.TransformId
		INNER JOIN dbo.TransformDefinition as td with(nolock) on t.TransformId = td.TransformId
		INNER JOIN dbo.TransformTarget as tt with(nolock) on td.TransformTargetId = tt.TransformTargetId
		INNER JOIN dbo.TransformMapping as tm with(nolock) on tt.TransformTargetId = tm.TransformTargetId 
		LEFT JOIN dbo.TransformClientMapping as tcm with(nolock) on 
			c.Client_id=tcm.Client_id and 
			c.Study_id=tcm.Study_id and 
			c.Survey_id = tcm.Survey_id and
			tm.TransformMappingId = tcm.TransformMappingId
	WHERE 
		c.Client_id=@Client_id and
		c.Study_id=@Study_id and
		c.Survey_id=@Survey_id		
END
GO
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