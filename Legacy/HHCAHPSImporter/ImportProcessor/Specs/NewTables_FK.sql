ALTER TABLE dbo.ClientTransform ADD CONSTRAINT
FK_ClientTransform_Transform FOREIGN KEY
(
	TransformId
) 
REFERENCES dbo.Transform
(
	TransformId
)
GO

ALTER TABLE dbo.TransformClientMapping ADD CONSTRAINT
FK_TransformClientMapping_TransformMapping FOREIGN KEY
(
	TransformMappingId
) 
REFERENCES dbo.TransformMapping
(
	TransformMappingId
)
GO

ALTER TABLE dbo.TransformMapping ADD CONSTRAINT
FK_TransformMapping_TransformTarget FOREIGN KEY
(
	TransformTargetId
) 
REFERENCES dbo.TransformTarget
(
	TransformTargetId
)
GO

ALTER TABLE dbo.TransformImports ADD CONSTRAINT
FK_TransformImports_TransformLibrary FOREIGN KEY
(
	TransformLibraryId
) 
REFERENCES dbo.TransformLibrary
(
	TransformLibraryId
)
GO

ALTER TABLE dbo.TransformImports ADD CONSTRAINT
FK_TransformImports_Transform FOREIGN KEY
(
	TransformId
) 
REFERENCES dbo.Transform
(
	TransformId
)
GO

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
