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