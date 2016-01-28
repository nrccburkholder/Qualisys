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