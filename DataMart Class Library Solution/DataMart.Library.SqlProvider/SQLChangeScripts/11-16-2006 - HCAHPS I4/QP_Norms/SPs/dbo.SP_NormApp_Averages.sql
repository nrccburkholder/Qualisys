set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO



















/*****************************************************************************
	SP_NormApp_Averages

	Description:  This Stored Procedure produce Average scores

	input: 
		@queue_id - This is the ID number for the request to be worked on



******************************************************************************/
ALTER                  procedure [dbo].[SP_NormApp_Averages]
	@measureType tinyint,
	@groupingType smallint
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
exec sp_normApp_timer 0, 'Starting SP_NormApp_Averages'
Declare @offset varchar(60), @sql varchar(8000)

select @offset=offset
from groupings
where grouping_id=@groupingType

create table #TempAverage (IDNum int, nsize int, Score decimal(12,5))

if @GroupingType =0
BEGIN
	insert into #TempAverage 
	select 
		coalesce(r.questiongroup_id, r.qstncore), 
		sum(r.nsize), 
		sum(r.val*r.nsize*1.0)/sum(r.nsize)
	from #questionresults r, questionvals qv
	where r.qstncore=qv.qstncore and
		  r.val=qv.val
	group by coalesce(r.questiongroup_id, r.qstncore)

	select 'Question' as Type,
		q.qstncore as ID, 
		l.[Report Text],
		'Mean' as Grouping,
		nsize, 
		convert(decimal(12,5),Score) as Score
	from #TempAverage r, #labels l, #questions q
	where q.qstncore=l.qstncore and
		  r.IDNum=coalesce(q.questiongroup_id, q.qstncore) and
		  q.bitSelected=1
	union all
	select 'Dimension',
		d.dimension_id,  
		d.strdimension_nm,
		'Mean' as Grouping,
		sum(r.nsize) as nsize, 
		convert(decimal(12,5),sum(r.val*r.nsize*1.0)/sum(r.nsize))
	from #dimensionresults r, Dimensions d, questionvals qv
	where r.dimension_id=d.dimension_id and
		  r.qstncore=qv.qstncore and
		  r.val=qv.val
	group by d.dimension_id,  
		d.strdimension_nm
	order by Type, [Report Text]
END
ELSE IF @GroupingType =998
BEGIN
		insert into #TempAverage 
		select 
			coalesce(r.questiongroup_id, r.qstncore), 
			sum(r.nsize), 
			convert(decimal(12,5),(sum(ps.problem_score_flag*r.nsize*1.0)/sum(r.nsize))* 100)
		from #questionresults r, qp_comments.dbo.lu_problem_score ps
		where r.qstncore=ps.qstncore and
				r.val=ps.val and
				ps.problem_score_flag in (0,1)
		group by coalesce(r.questiongroup_id, r.qstncore)
	
		select 'Question' as Type,
			q.qstncore as ID, 
			l.[Report Text],
			'%Problem Score' as Grouping,
			nsize,
			Score
		from #TempAverage r, #Labels l, #questions q
		where q.qstncore=l.qstncore and
			  r.IDNum=coalesce(q.questiongroup_id, q.qstncore) and
			  q.bitSelected=1
		union all
			select 'Dimension',
			d.dimension_id, 
			d.strdimension_nm,
			'%Problem Score' as Grouping,
			sum(r.nsize) as nsize,convert(decimal(12,5),(sum(ps.problem_score_flag*r.nsize*1.0)/sum(r.nsize))* 100)
		from #dimensionresults r, qp_comments.dbo.lu_problem_score ps, Dimensions d
		where r.qstncore=ps.qstncore and
			r.val=ps.val and
			ps.problem_score_flag in (0,1) and
			r.dimension_id=d.dimension_id
		group by d.dimension_id, 
			d.strdimension_nm				
		order by Type, [Report Text]				
END
ELSE IF @GroupingType=999
BEGIN
		insert into #TempAverage 
		select 
			coalesce(r.questiongroup_id, r.qstncore), 
			sum(r.nsize), 
			100 - convert(decimal(12,5),(sum(ps.problem_score_flag*r.nsize*1.0)/sum(r.nsize))* 100)
		from #questionresults r, qp_comments.dbo.lu_problem_score ps
		where r.qstncore=ps.qstncore and
				r.val=ps.val and
				ps.problem_score_flag in (0,1)
		group by coalesce(r.questiongroup_id, r.qstncore)

		select 'Question' as Type,
			q.qstncore as ID, 
			l.[Report Text],
			'%Positive Score' as Grouping,
			nsize,
			Score
		from #TempAverage r, #Labels l, #questions q
		where q.qstncore=l.qstncore and
			  r.IDNum=coalesce(q.questiongroup_id, q.qstncore) and
			  q.bitSelected=1
		union all
			select 'Dimension',
			d.dimension_id, 
			d.strdimension_nm,
			'%Positive Score' as Grouping,
			sum(r.nsize) as nsize,
			100 - convert(decimal(12,5),(sum(ps.problem_score_flag*r.nsize*1.0)/sum(r.nsize))* 100)
		from #dimensionresults r, qp_comments.dbo.lu_problem_score ps, Dimensions d
		where r.qstncore=ps.qstncore and
			r.val=ps.val and
			ps.problem_score_flag in (0,1) and
			r.dimension_id=d.dimension_id
		group by d.dimension_id, 
			d.strdimension_nm				
		order by Type, [Report Text]
END
ELSE IF @measureType=2
BEGIN
	set @sql='insert into #TempAverage 
		select 
			coalesce(r.questiongroup_id, r.qstncore), 
			sum(r.nsize), 
			(sum(case
					when ' + @offset +' then 1
					else 0
				 end*r.nsize*1.0)/sum(r.nsize))*100
		from #questionresults r, questionvals q
		where r.qstncore=q.qstncore and
				r.val=q.val and
				q.scaleorder>0
		group by coalesce(r.questiongroup_id, r.qstncore)

		select ''Question'' as type,
			q.qstncore as ID, 
			l.[Report Text],
			pq.label as Grouping,
			nsize, 
			Score
		from #TempAverage r, #questions q, #PercentLabels pq, #labels l
		where 	r.IDNum=coalesce(q.questiongroup_id, q.qstncore) and
				q.qstncore=pq.ID and
				pq.bitdimension=0 and
				q.bitSelected=1 and
				q.qstncore=l.qstncore
		union all
		select ''Dimension'' as type,
			d.dimension_id, 
			d.strdimension_nm,
			pq.label as Grouping,
			sum(r.nsize) as nsize, 
			convert(decimal(12,5),
			(sum(case
					when  ' + @offset +' then 1
					else 0
				 end*r.nsize*1.0)/sum(r.nsize))*100) as Score
		from #dimensionresults r, questionvals q, #PercentLabels pq,
			 dimensions d
		where r.qstncore=q.qstncore and
				r.val=q.val and
				q.scaleorder>0 and
				r.dimension_id=pq.ID and
				r.dimension_id=d.dimension_id and
				pq.bitdimension=1
		group by d.dimension_id, 
			d.strdimension_nm,
			pq.label
		order by Type, [Report Text]'

	--print (@sql)
	EXEC (@sql)

END
exec sp_normApp_timer 0, 'Ending SP_NormApp_Averages'




















