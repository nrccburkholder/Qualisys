ALTER TABLE dbo.TransformDefinition ADD CONSTRAINT
FK_TransformDefinition_Transform FOREIGN KEY
(
	TransformId
) 
REFERENCES dbo.Transform
(
	TransformId
)
GO

ALTER TABLE dbo.TransformDefinition ADD CONSTRAINT
FK_TransformDefinition_TransformTarget FOREIGN KEY
(
	TransformTargetId
) 
REFERENCES dbo.TransformTarget
(
	TransformTargetId
)
GO
