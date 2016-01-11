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