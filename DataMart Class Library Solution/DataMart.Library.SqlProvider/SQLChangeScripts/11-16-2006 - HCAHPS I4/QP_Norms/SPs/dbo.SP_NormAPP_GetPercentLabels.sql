set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF
GO





















/*****************************************************************************
	SP_NormAPP_GetPercentLabels

	Description:  This Stored Procedure will build a file with labels for the
					Percent Groupings

	input: 
		@GroupingType - This is type of grouping being used
		@bitQuestions - Indicates whether we have a specific list of questions
						to use



******************************************************************************/
ALTER                      PROCEDURE [dbo].[SP_NormAPP_GetPercentLabels]
	@GroupingType smallint
as
exec sp_normApp_timer 0, 'Starting SP_NormAPP_GetPercentLabels'
DECLARE @sql varchar(500), @offset varchar(60), @intJoinNumberForLabels tinyint, @bitReversePercentileScores bit,
	@PrevioustempQstncore int, @tempQstncore int, @templabel varchar(500), @label varchar(62)

if @groupingType in (998,999)
Begin
	insert into #PercentLabels (bitdimension, ID, label)
		select distinct 1, d.dimension_id, g.strGrouping
		from #dimensions d, groupings g
		where g.grouping_id=@groupingType

	insert into #PercentLabels (bitdimension, ID, label)
		select 0, q.qstncore, g.strGrouping
		from #questions q, groupings g
		where g.grouping_id=@groupingType
End
Else
Begin
	--Question Labels start here
	create table #TempPercentQuestionLabels (qstncore int, Label varchar(60), scaleorder int, max_scaleorder int)
	create index qstnlabel on #TempPercentQuestionLabels (qstncore,label)

	Select @offset=offset,
		@intJoinNumberForLabels=intJoinNumberForLabels,
		@bitReversePercentileScores=bitReversePercentileScores
	from groupings
	where grouping_id=@groupingType

	set @sql='insert into #TempPercentQuestionLabels
		select distinct qv.qstncore, qv.Response_Label, qv.scaleorder, qv.max_scaleorder
		from questionvals qv, #questions q
		where q.qstncore=qv.qstncore and 
			qv.scaleorder>0 and
			' + @offset+'
		order by qv.qstncore, qv.scaleorder'

	exec(@sql)
	
	if @intJoinNumberForLabels=1
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label
		from #TempPercentQuestionLabels t
	ELSE if @intJoinNumberForLabels=2 and @bitReversePercentileScores=0 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2
		where t.qstncore=t2.qstncore and
				t.scaleorder=1 and
			  	t2.scaleorder=2	
	ELSE if @intJoinNumberForLabels=3 and @bitReversePercentileScores=0 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label + '/' + t3.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2, #TempPercentQuestionLabels t3
		where t.qstncore=t2.qstncore and
				t.qstncore=t3.qstncore and
				t.scaleorder=1 and
			  	t2.scaleorder=2	and
				t3.scaleorder=3
	ELSE if @intJoinNumberForLabels=4 and @bitReversePercentileScores=0 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label + '/' + t3.label + '/' + t4.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2, #TempPercentQuestionLabels t3, #TempPercentQuestionLabels t4
		where t.qstncore=t2.qstncore and
				t.qstncore=t3.qstncore and
				t.qstncore=t4.qstncore and
				t.scaleorder=1 and
			  	t2.scaleorder=2	and
				t3.scaleorder=3 and
				t4.scaleorder=4
	ELSE if @intJoinNumberForLabels=2 and @bitReversePercentileScores=1 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2
		where t.qstncore=t2.qstncore and
				t.scaleorder=t.max_scaleorder-1 and
			  	t2.scaleorder=t.max_scaleorder	
	ELSE if @intJoinNumberForLabels=3 and @bitReversePercentileScores=1 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label + '/' + t3.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2, #TempPercentQuestionLabels t3
		where t.qstncore=t2.qstncore and
				t.qstncore=t3.qstncore and
				t.scaleorder=t.max_scaleorder-2 and
			  	t2.scaleorder=t.max_scaleorder-1	and
				t3.scaleorder=t.max_scaleorder
	ELSE if @intJoinNumberForLabels=4 and @bitReversePercentileScores=1 
		insert into #PercentLabels (bitdimension, ID, label)
		select 0, t.qstncore, '%' + t.label + '/' + t2.label + '/' + t3.label + '/' + t4.label
		from #TempPercentQuestionLabels t, #TempPercentQuestionLabels t2, #TempPercentQuestionLabels t3, #TempPercentQuestionLabels t4
		where t.qstncore=t2.qstncore and
				t.qstncore=t3.qstncore and
				t.qstncore=t4.qstncore and
				t.scaleorder=t.max_scaleorder-3 and
			  	t2.scaleorder=t.max_scaleorder-2	and
				t3.scaleorder=t.max_scaleorder-1 and
				t4.scaleorder=t.max_scaleorder

	--Dimension Labels start here
	DECLARE @Previoustempdimension int, @tempdimension int

	create table #TempPercentDimensionLabels (dimension_id int, Label varchar(60), scaleorder int)
	create index dimlabel on #TempPercentDimensionLabels (dimension_id,label)

	set @sql='insert into #TempPercentDimensionLabels
		select distinct d.dimension_id, qv.Response_Label, qv.scaleorder
		from questionvals qv, #dimensions d
		where d.qstncore=qv.qstncore 
			and qv.scaleorder>0
			and ' + @offset+'
		order by d.dimension_id, qv.scaleorder'

	exec(@sql)
	
	set @templabel=''
	select top 1 @tempDimension=dimension_id, 
		@PrevioustempDimension=dimension_id, 
		@Label=label
	from #TempPercentDimensionLabels

	while @@rowcount > 0
	BEGIN
		IF @tempLabel = '' set @tempLabel='% ' + @label 
		ELSE IF @PrevioustempDimension=@tempDimension set @tempLabel=@tempLabel + '/' + @label
		ELSE 
		BEGIN
			insert into #PercentLabels (bitdimension, id, label)
				values (1, @PrevioustempDimension, @tempLabel)
			set @tempLabel='% ' + @label 
		END

		delete 
		from #TempPercentDimensionLabels
		where Dimension_id=@tempDimension and
				label=@label

		set @PrevioustempDimension=@tempDimension

		select top 1 @tempDimension=Dimension_id, @Label=label
		from #TempPercentDimensionLabels
	END
	--Insert the last Dimension
	insert into #PercentLabels (bitdimension, id, label)
		values (1, @PrevioustempDimension, @tempLabel)
	
END	
exec sp_normApp_timer 0, 'Ending SP_NormAPP_GetPercentLabels'





















