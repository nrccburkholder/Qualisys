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