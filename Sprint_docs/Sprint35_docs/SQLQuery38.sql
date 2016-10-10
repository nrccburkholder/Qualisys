

select *
FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.client_id  
	 WHERE dsk.DataSourceID = 1
	   AND dsk.EntityTypeID = 1 -- Client
	   AND lt.DataFileID = 7112
	
	select*
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.id 
	 WHERE dsk.DataSourceID = 1
	   AND dsk.EntityTypeID = 8
	   AND lt.DataFileID = 7112
	
	--------------------------------------------------------------------------------------
	-- Insert new records 
	--------------------------------------------------------------------------------------

		SELECT 1, 8, id
		  FROM LOAD_TABLES.SampleSet WITH (NOLOCK)
		 WHERE DataFileID = 7112
		   AND isInsert <> 0 AND isDelete = 0 AND ClientID IS NOT NULL

	select *
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.id 
	 WHERE dsk.DataSourceID = 1
	   AND dsk.EntityTypeID = 8
	   AND lt.DataFileID = 7112
	   AND lt.isInsert <> 0 AND isDelete = 0


		SELECT SampleSetID, ClientID, CONVERT(DATE,SampleDate)
		,StandardMethodologyID -- 2.0
		,IneligibleCount  -- 3.0
		,SamplingMethodID -- S20 US9
		,datFirstMailed -- S35 US17
		  FROM LOAD_TABLES.SampleSet WITH (NOLOCK)
		 WHERE DataFileID = 7112
		   AND isInsert <> 0 AND isDelete = 0 AND ClientID IS NOT NULL


select *
from etl.DataSourceKey
where DataSourceKeyID = 189270854
and EntityTypeID = 8

select * from LOAD_TABLES.SampleSet
WHERE DataFileID = 7112

select *
from sampleset
where samplesetid = 189270854


--delete
--from etl.DataSourceKey
--where DataSourceKeyID = 189270854
--and EntityTypeID = 8