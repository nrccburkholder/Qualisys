CREATE        procedure QP_Rep_SamplePlanWorkSheetDQExpanded
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

IF EXISTS (SELECT sampleset_id from sampleplanworksheet WHERE sampleset_id=@intsampleset_id)
BEGIN
	 create table #SampleUnits
	  (SampleUnit_id int,
	   strSampleUnit_nm varchar(255),
	   intTier int,
	   intTreeOrder int)
	
	 declare @intSamplePlan_id int
	 select @intSamplePlan_id=sampleplan_id from sampleset where sampleset_id=@intSampleset_id
	 exec sp_SampleUnits @intSamplePlan_id
	
	DECLARE @SQL varchar(4000), @sampleunit_id int, @DQ varchar(8), @N int
	
	CREATE TABLE #DQ (SampleUnit varchar(60), Tier int, [Unit ID] int, TotalDQ int)
	
	INSERT INTO #DQ (SampleUnit, Tier, [Unit ID], TotalDQ)
	SELECT strSampleUnit_nm, inttier, sampleunit_Id,0 
	FROM #sampleunits
	
	CREATE TABLE #Removed_Rules (DQrr varchar(8))
	Insert into #Removed_Rules values ('Resurvey')
	Insert into #Removed_Rules values ('NewBorn')
	Insert into #Removed_Rules values ('TOCL')
	Insert into #Removed_Rules values ('DQRule')
	Insert into #Removed_Rules values ('ExcEnc')
	Insert into #Removed_Rules values ('HHMinor')
	Insert into #Removed_Rules values ('HHAdult')
	Insert into #Removed_Rules values ('SSRemove')
	
	/*Transpose the Table*/
	DECLARE TransposeCursor CURSOR
		FOR SELECT DQ
			FROM (SELECT distinct top 1000 replace(s.DQ, 'DQ_','') as DQ, r.DQrr
				  FROM SPWDQCounts s left join #Removed_Rules r
					ON s.DQ=r.DQrr
					WHERE sampleset_id=@intsampleset_id
					ORDER BY r.DQrr) s
	OPEN TransposeCursor
	Fetch Next From TransposeCursor INTO @DQ
	WHILE @@Fetch_Status = 0
	BEGIN
	
		SET @SQL='ALTER TABLE #DQ ' + 
				  'ADD [' + @DQ + '] int null'
		EXEC (@SQL)
		Fetch Next From TransposeCursor INTO @DQ
	END
	
	CLOSE TransposeCursor
	DEALLOCATE TransposeCursor
	
	/*Populate the Transposed Table*/
	
	DECLARE PopulateCursor CURSOR
		FOR SELECT SAMPLEUNIT_ID, replace(DQ, 'DQ_','') as DQ, N
			FROM SPWDQCounts
			WHERE sampleset_id=@intsampleset_id
	OPEN PopulateCursor
	Fetch Next From PopulateCursor INTO @sampleunit_id, @DQ, @N
	WHILE @@Fetch_Status = 0
	BEGIN
		SET @SQL=''
			SET @SQL='UPDATE #DQ ' +
					 'SET [' + @DQ + ']=' + convert(varchar,@N) + 
					 ',	TotalDQ = TotalDQ + ' + convert(varchar,@N) + 
					 ' WHERE [Unit ID]= ' + convert(varchar,@sampleunit_id)
		EXEC (@SQL)
		Fetch Next From PopulateCursor INTO @sampleunit_id, @DQ, @N
	END
	
	CLOSE PopulateCursor
	DEALLOCATE PopulateCursor
	
	/*Check for null values and replace with 0*/
	DECLARE TransposeCursor CURSOR
		FOR SELECT DISTINCT replace(DQ, 'DQ_','') as DQ
			FROM SPWDQCounts
			WHERE sampleset_id=@intsampleset_id
			ORDER BY DQ
	OPEN TransposeCursor
	Fetch Next From TransposeCursor INTO @DQ
	WHILE @@Fetch_Status = 0
	BEGIN
	
		SET @SQL='Update #DQ ' + 
				  'Set [' + @DQ + '] = 0' +
				  'WHERE [' + @DQ + ']is null'
		EXEC (@SQL)
		Fetch Next From TransposeCursor INTO @DQ
	END
	
	CLOSE TransposeCursor
	DEALLOCATE TransposeCursor

	select *
	from #DQ 
	
	DROP TABLE #DQ
END
Else
BEGIN
	Select ' ' as [ ]
END


update  dashboardlog 
set procedureend = getdate()
where report = 'Sample Plan Worksheet'
and associate = @associate
and client = @client
and study = @study
and survey = @survey
and sampleset = @sampleset
and procedureend is null


set transaction isolation level read committed


