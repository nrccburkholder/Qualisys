INSERT INTO dbo.Transform (TransformName, CreateUser) VALUES('OCS HHCAHPS', 'nrc\aaliabadi')
INSERT INTO dbo.TransformTarget(TargetName,TargetTable,CreateUser) VALUES('OCS HHCAHPS Encounter', 'Encounter_Load', 'nrc\aaliabadi')
INSERT INTO dbo.TransformTarget(TargetName,TargetTable,CreateUser) VALUES('OCS HHCAHPS Population', 'Population_Load', 'nrc\aaliabadi')
INSERT INTO dbo.TransformDefinition select TransformId,TransformTargetId,getdate(),'nrc\aaliabadi',null,null from dbo.Transform as a, dbo.TransformTarget as b

-- this assumes 1 is the OCS HHCAHPS Transform
INSERT INTO dbo.ClientTransform SELECT Client_id,Study_id,Survey_id,1,getdate(),'nrc\aaliabadi',null,null from dbo.ClientDetail