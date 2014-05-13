set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*****************************************************************************
	SP_NormApp_BuildNorm

	Description:  This Stored Procedure will produce a norm for APB.  It must
				  be call from SP_NormApp_Master

	

******************************************************************************/
ALTER                                                            PROCEDURE [dbo].[SP_NormApp_BuildNorm] 
	@bitFacility bit,
	@bitMinimumClientCheck bit,
	@requestType tinyint,
	@norm_id int,
	@userID int
as
exec sp_normApp_timer 0, 'Starting SP_NormApp_BuildNorm'
DECLARE @measuretype tinyint, @groupingType smallint, @bitPercentilesType int, @bitReversePercentileScores bit,
		@bitPercentiles bit, @bitTopN bit, @bitBest bit, @bitStandard bit,
		@PercentilesComptype_Id int, @BestComptype_Id int,
		@StandardComptype_id int, @aggregateLocation varchar(100), @sql varchar(8000),
		@alternateAggregateNorm_id int, @AlternateaggregateLocation varchar(100)

create table #TOPNParams (normparam tinyint, comptype_id int)

Select @bitPercentiles=1, @PercentilesComptype_Id=comptype_id
from dbo.tbl_comparisondef_staging
where norm_id=@norm_id and
	normtype = 4

select @bitTopN=1
from dbo.tbl_comparisondef_staging
where norm_id=@norm_id and
	normtype =2

select @bitbest=1, @BestComptype_Id=comptype_id
from dbo.tbl_comparisondef_staging
where norm_id=@norm_id and
	normtype =6

select @bitStandard=1, @StandardComptype_id=comptype_id
from dbo.tbl_comparisondef_staging
where norm_id=@norm_id and
	normtype =1

select @aggregateLocation=aggregateLocation
from dbo.normsettings_staging
where norm_id=@norm_id

select @alternateAggregateNorm_id=alternateAggregateLevelNorm_id
from dbo.normsettings_staging
where norm_id=@norm_id

select @AlternateaggregateLocation=aggregateLocation
from dbo.normsettings_staging
where norm_id=@alternateAggregateNorm_id

--Create Standard Norm
if @bitStandard=1
Begin
	Create table #NormTempBreakout 
		(type varchar(20), ID int, [Report Text] varchar(60),val int, 
		[Response Label] varchar(120), nsize int, [%] decimal(12,5))

	insert into #NormTempBreakout
	exec SP_NormApp_Breakouts

	create table #normStandard (comptype_id int, qstncore int, val int, nsize int)

	insert into #normStandard (comptype_id, qstncore, val, nsize)
	select @standardcomptype_id, ID, val, nsize
	from #NormTempBreakout

	--begin tran

		delete 
		from dbo.norm_standard
		where comptype_id=@standardcomptype_id

		insert into dbo.norm_standard (comptype_id, qstncore, intresponseval, nsize)
		select comptype_id, qstncore, val, nsize
		from #normStandard
	--if @@error= 0 Commit Tran
	--else Rollback Tran
End

if @bitPercentiles=1 or @bitTopN=1 or @bitBest=1
Begin
	set @bitPercentilesType=0
	--Create Aggregate Table used for calculating dimension scores on the fly
		Create table #NormTempAggregate 
			(group_id int, qstncore int, val int, nsize int)
	
		insert into #NormTempAggregate (group_id, qstncore, val, nsize)
		select group_id, qstncore, val, nsize
		from #Questionresults

	--begin tran

		set @sql='		

			if Exists (select table_name
							from information_schema.tables
							where table_name=''' + @aggregateLocation +''')
			begin
				drop table dbo.' + @aggregateLocation + '
			END	
		
				create table dbo.' + @aggregateLocation + ' (group_id int Not Null, qstncore int Not Null, intresponseval int Not Null, nsize int Not Null,
														CONSTRAINT [PK_' + @aggregateLocation + '] PRIMARY KEY  CLUSTERED 
														(	[group_id],
															[qstncore],
															[intresponseval]
														)  ON [PRIMARY] )

			insert into dbo.' + @aggregateLocation + ' (group_id, qstncore, intresponseval, nsize)
			select group_id, qstncore, val, nsize
			from #NormTempAggregate'
	
		exec (@sql)
	--if @@error= 0 Commit Tran
	--else Rollback Tran

	--Create AltenateAggregate Table used for calculating dimension scores on the fly
	if @AlternateaggregateLocation is not null
	BEGIN
			Create table #NormTempAlternateAggregate 
				(group_id int, qstncore int, val int, nsize int)		
		
			insert into #NormTempAlternateAggregate (group_id, qstncore, val, nsize)
			select sufacility_id as group_id, qstncore, val, sum(nsize) as nsize
			from #NormTempAggregate n, sampleunit s
			where n.group_id=s.sampleunit_id and
					sufacility_id is not null
			group by sufacility_id, qstncore, val
	
		--begin tran
	
			set @sql='		
	
				if Exists (select table_name
								from information_schema.tables
								where table_name=''' + @AlternateaggregateLocation +''')
				begin
					drop table dbo.' + @AlternateaggregateLocation + '
				END	
			
					create table dbo.' + @AlternateaggregateLocation + ' (group_id int Not Null, qstncore int Not Null, intresponseval int Not Null, nsize int Not Null,
															CONSTRAINT [PK_' + @AlternateaggregateLocation + '] PRIMARY KEY  CLUSTERED 
															(	[group_id],
																[qstncore],
																[intresponseval]
															)  ON [PRIMARY] )
	
				insert into dbo.' + @AlternateaggregateLocation + ' (group_id, qstncore, intresponseval, nsize)
				select group_id, qstncore, val, nsize
				from #NormTempAlternateAggregate'
		
			exec (@sql)
		--if @@error= 0 Commit Tran
		--else Rollback Tran
	END

--Adjust question data to have map all data to each equivalent core number
	--Create a list of 0-100 Percentiles, top25, top10, and best
	Create table #NormTempPercentile 
		(type varchar(20), ID int, [Report Text] varchar(60), grouping varchar(500),
		score decimal(12,5), percentile int)
	create table #normPct (comptype_id int, qstncore int, measureType tinyint, groupingType smallint, percentile tinyint, score decimal(9,5))
	create index percentile on #normPct (percentile)
	create index measGrouppct on #normPct (measuretype, groupingType, percentile)
	create table #measureGroups (measuretype tinyint, groupingtype smallint)

	create table #norm_Benchmark (comptype_id int, qstncore int, measureType tinyint, groupingType smallint, val int, nsize int)
	
	insert into #measuregroups
	select measuretype_id, grouping_id
	from groupings
	where grouping_id <> 999  --Don't include Positive Score

	select top 1 @measuretype=measuretype,
				 @groupingType=groupingtype
	from #measureGroups

	While @@rowcount>0
	BEGIN
		
		select @bitReversePercentileScores=bitReversePercentileScores
		from groupings
		where grouping_id=@groupingtype

		if @measuretype<>1 exec SP_NormAPP_GetPercentLabels @GroupingType

		--Catch the output so it doesn't write to grid
		insert into #NormTempPercentile (type, ID, [Report Text], grouping,	score, percentile)
		exec SP_NormApp_Percentiles @measuretype, @groupingType, @bitPercentilesType, @bitFacility, @bitMinimumClientCheck ,@requesttype

		if @bitPercentiles=1
			insert into #normPct (comptype_id, qstncore, measureType, groupingType, percentile, score)
			select @PercentilesComptype_Id, ID, @measuretype, @groupingType, percentile, score 
			from #Percentiles1to100

		--update percentiles so that anyone with the same score gets the same percentile
		update #PercentilesList
		set percentile=s.percentile
		from #PercentilesList pl, 
			(select bitDimension, ID, score, max(percentile) as percentile
				from #PercentilesList pl
				group by bitDimension, ID, score) s
		where pl.bitDimension=s.bitDimension and
			pl.ID=s.ID and
			pl.score=s.score

		exec sp_normApp_timer 0, 'Starting Norms Get Top10, Top25, and best'

		if @bitTopN=1
		BEGIN

			truncate table #TOPNParams
			insert into #TOPNParams
			select normParam, comptype_id
			from dbo.tbl_comparisondef_staging
			where norm_id=@norm_id and
				normtype =2

			declare @topN tinyint, @comptype_id int

			select top 1 @TopN=NormParam, @comptype_id=comptype_id
			from #TOPNParams

			While @@rowcount > 0
			Begin

				insert into #norm_Benchmark (comptype_id, qstncore, measureType, groupingType, val, nsize)
				select @Comptype_Id, n.qstncore, @measuretype, @groupingtype, 
					n.val, sum(n.nsize) as nsize
				from #questionresults n, #PercentilesList p
				where p.percentile>=(100 - @TopN) and
					  --p.bitdimension=0 and
					  n.group_id=p.group_id and
					  n.qstncore=p.ID
				group by n.qstncore, n.val
				order by n.qstncore, n.val

				delete 
				from #TOPNParams
				where NormParam= @TopN

				select top 1 @TopN=NormParam, @comptype_id=comptype_id
				from #TOPNParams
			End
		END

		if @bitReversePercentileScores=1 and @bitBest=1
			insert into #norm_Benchmark (comptype_id, qstncore, measureType, groupingType, val, nsize)
			select @bestComptype_Id, n.qstncore, @measuretype, @groupingtype, 
				n.val, sum(n.nsize) as nsize
			from #questionresults n, 
					(select ID, min(score) as score
					from #PercentilesList
					--where bitdimension=0
					group by ID) pm,
				 #percentileslist p
			where pm.ID=p.ID and
				  pm.score=p.score and
				  p.ID=n.qstncore and
				  n.group_id=p.group_id
			group by n.qstncore, n.val
			order by n.qstncore, n.val
		ELSE if @bitbest=1
			insert into #norm_Benchmark (comptype_id, qstncore, measureType, groupingType, val, nsize)
			select @BestComptype_Id, n.qstncore, @measuretype, @groupingtype, 
				n.val, sum(n.nsize) as nsize
			from #questionresults n, 
					(select ID, max(score) as score
					from #PercentilesList
					--where bitdimension=0
					group by ID) pm,
				 #percentileslist p
			where pm.ID=p.ID and
				  pm.score=p.score and
				  p.ID=n.qstncore and
				  n.group_id=p.group_id
			group by n.qstncore, n.val
			order by n.qstncore, n.val

		truncate table #UnitListScores
		truncate table #PercentilesList
		truncate table #Percentiles1to100
		--truncate table #NormTempPercentile
		truncate table #PercentLabels

		update #questionresults
		set bitdelete=0

		update #dimensionResults
		set bitDelete=0

		delete 
		from #measureGroups
		where groupingType=@groupingType and
			  measuretype=@measuretype

		exec sp_normApp_timer 0, 'Ending Norms Top10, Top25, and best'

		select top 1 @measuretype=measuretype,
					 @groupingType=groupingtype
		from #measureGroups

	END

	--begin tran

		delete 
		from dbo.norm_percentile
		where comptype_id=@PercentilesComptype_Id

		insert into dbo.norm_percentile (comptype_id, qstncore, measureType, grouping, percentile, value)
		select comptype_id, qstncore, measureType, groupingType, percentile, score
		from #Normpct
	--if @@error= 0 Commit Tran
	--else 
	--begin
	--	print 'Percentiles insert error'
	--	Rollback Tran
	--end

	--begin tran
	
		create table #benchmarkGroups (comptype_id int, qstncore int, measuretype int, groupingtype int, val int, 
					nsize int)
		
		insert into #benchmarkGroups
		select comptype_id, q.qstncore, measuretype, groupingtype, val, nsize
		from (select comptype_id, q.questiongroup_id, measuretype, groupingtype, val, sum(nsize) as nsize
				from #norm_Benchmark b, #questions q
				where b.qstncore=q.qstncore and
					q.questiongroup_id is not null
				group by comptype_id, q.questiongroup_id, measuretype, groupingtype, val) g,
			#questions q
		where g.questiongroup_id=q.questiongroup_id
		order by comptype_id, q.qstncore, measuretype, groupingtype, val
		
		delete b
		from #norm_Benchmark b, #benchmarkGroups g
		where b.comptype_id=g.comptype_id and
				b.qstncore=g.qstncore and
				b.measuretype=g.measuretype and
				b.groupingtype=g.groupingtype
		
		insert into #norm_Benchmark
		select *
		from #benchmarkGroups

		delete 
		from dbo.norm_Benchmark
		where comptype_id in 
			(select comptype_id
				from dbo.tbl_comparisondef_staging
				where norm_id=@norm_id)

		insert into dbo.norm_Benchmark (comptype_id, qstncore, measureType, grouping, intresponseval, nsize)
		select comptype_id, qstncore, measureType, groupingType, val, nsize
		from #norm_Benchmark
	--if @@error= 0 Commit Tran
	--else 
	--begin
	--	print 'Benchmark insert error'
	--	Rollback Tran
	--end

End

--Run finalize SP for each norm
exec sp_normApp_timer 0, 'Starting finalize Norm'

exec NRM_CM_FinalizeNorm @norm_ID
if @alternateAggregateNorm_id is not null exec NRM_CM_FinalizeNorm @alternateAggregateNorm_id 


exec sp_normApp_timer 0, 'Ending finalize Norm'

insert into NormsUpdateLog (norm_id) values (@norm_id)
exec sp_normApp_timer 0, 'Ending SP_NormApp_BuildNorm'

update dbo.normsettings_staging
set updatedate=getdate(),
	updatedby=@userID
where norm_id in (@norm_id,@alternateAggregateNorm_id)


