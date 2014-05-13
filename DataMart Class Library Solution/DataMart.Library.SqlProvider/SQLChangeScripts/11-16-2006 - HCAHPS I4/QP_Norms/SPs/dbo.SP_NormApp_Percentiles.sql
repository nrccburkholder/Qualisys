set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF
GO



























/*****************************************************************************
	SP_NormApp_Percentiles

	Description:  This Stored Procedure will produce percentiles 

	input: 
		@queue_id - This is the ID number for the request to be worked on



******************************************************************************/
ALTER                                                                PROCEDURE [dbo].[SP_NormApp_Percentiles] 
	@measuretype tinyint,
	@groupingType smallint, 
	@bitPercentilesType bit,
	@bitFacility bit,
	@bitMinimumClientCheck bit,
	@requestType tinyint
as
Declare @bitReversePercentileScores bit, @sql varchar(8000), @offset varchar(60), @Note varchar(100)
set @Note='Starting SP_NormApp_Percentiles measureType=' + convert(varchar,@measureType) + ', groupingType=' + 
			convert(varchar,@groupingType)

exec sp_normApp_timer 0, @Note

select @bitReversePercentileScores=bitReversePercentileScores,
		@offset=offset
from groupings
where grouping_id=@groupingType

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	create table #UnitListScorestemp (group_id int, bitDimension bit, ID int, nsize int, score decimal(12,5))
	create index group_id on #UnitListScorestemp (group_id) 

--If it is not a norm, 
if @requestType<>6
BEGIN
	--Questionval only includes responses that are not bitmissing so this join
	--will remove the bitmissing values
	if @GroupingType not in (998,999)
	BEGIN
		update n 
		set bitDelete=1
		from #questionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
			  n.val=qv.val
		where qv.val is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
			  n.val=qv.val
		where qv.val is null
	END
END
Else
BEGIN
	--Reduce the number of questions that need to be analyzed based on
	--the measure and grouping for norms
	if @GroupingType in (998,999)
	BEGIN
		select distinct qstncore
		into #probCores
		from questionvals
		where bitprobscore=1

		update n 
		set bitDelete=1
		from #questionresults n left join #probCores qv
			on n.qstncore=qv.qstncore
		where qv.qstncore is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join #probCores qv
			on n.qstncore=qv.qstncore
		where qv.qstncore is null
	END
	ELSE if @groupingType=0
	BEGIN
		update n 
		set bitDelete=1
		from #questionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
				n.val=qv.val and
				qv.bitmeanable=1
		where qv.qstncore is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
				n.val=qv.val and
				qv.bitmeanable=1
		where qv.qstncore is null
	END

END

/*Minimum nsize check*/
if @GroupingType in (998,999)
BEGIN
		update q
		set bitDelete=1
		from #questionresults q,
			(select group_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #questionresults q, qp_comments.dbo.lu_problem_score ps
				where q.qstncore=ps.qstncore and
					q.val=ps.val and
					ps.problem_score_flag in (0,1)
				group by group_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where q.group_id=dr.group_id and
				coalesce(1000000+questiongroup_id, q.qstncore)=dr.IDNum  

		--If any question fails nsize rule, delete entire dimension
		update d
		set bitDelete=1
		from #dimensionresults d,
			(select group_id, dimension_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #dimensionresults q, qp_comments.dbo.lu_problem_score ps
				where q.qstncore=ps.qstncore and
					q.val=ps.val and
					ps.problem_score_flag in (0,1)
				group by group_id, dimension_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				d.dimension_id=dr.dimension_id 
END
ELSE 
BEGIN
		update d
		set bitDelete=1
		from #questionresults d,
			(select group_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #questionresults q, questionvals qv
				where q.qstncore=qv.qstncore and
						q.val=qv.val
				group by group_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				coalesce(1000000+questiongroup_id, qstncore)=dr.IDNum  

		--If any question fails nsize rule, delete entire dimension
		update d
		set bitDelete=1
		from #dimensionresults d,
			(select group_id, dimension_id, coalesce(1000000+questiongroup_id, d.qstncore) as IDNum
				from #dimensionresults d, questionvals qv
				where d.qstncore=qv.qstncore and
						d.val=qv.val
				group by group_id, dimension_id, coalesce(1000000+questiongroup_id, d.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				d.dimension_id=dr.dimension_id 
END

/*Check that All dimension Questions are in use*/
update d
set bitDelete=1
from #dimensionresults d,
	(select group_id, dimension_id, count(distinct coalesce(1000000+questiongroup_id, qstncore)) as questioncount
		from #dimensionresults dr
		group by group_id, dimension_id) dr, 
		(select dimension_id, count(distinct coalesce(1000000+questiongroup_id, qstncore)) as questioncount
			from #dimensions
			group by dimension_id) qc
where d.group_id=dr.group_id and
		d.dimension_id=dr.dimension_id and
		dr.dimension_id=qc.dimension_id and
		dr.questioncount < qc.questioncount

/*Calculate scores for each unit or Facility*/
if @measureType=1
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select group_id, 
						0 as bitDimension,
						coalesce(1000000+questiongroup_id, qstncore) as IDNum, 
						sum(nsize) as nsize, 
						sum(val*nsize*1.0)/sum(nsize) as Score 
					from #questionresults 
					where bitDelete=0
					group by group_id, 
						coalesce(1000000+questiongroup_id, qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select group_id,
			1 as bitDimension, 
			dimension_id as ID, 
			sum(nsize) as nsize, 
			sum(val*nsize*1.0)/sum(nsize) as Score 
		from #dimensionresults
		where bitDelete=0
		group by group_id, 
			dimension_id) s
		order by bitDimension, ID, score		
END	
ELSE if @GroupingType=999
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
					0 as bitDimension,
					coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
					sum(r.nsize) as nsize, 
					100 - (sum(ps.problem_score_flag*r.nsize*100.0)/sum(r.nsize)) as Score 
				from #questionresults r, qp_comments.dbo.lu_problem_score ps
				where r.qstncore=ps.qstncore and
					r.val=ps.val and
					ps.problem_score_flag in (0,1) and
					bitDelete=0
				group by r.group_id, 
					coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			100 - (sum(ps.problem_score_flag*d.nsize*100.0)/sum(d.nsize)) as Score 
		from #dimensionresults d, qp_comments.dbo.lu_problem_score ps
		where d.qstncore=ps.qstncore and
			d.val=ps.val and
			ps.problem_score_flag in (0,1) and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score	
END
ELSE if @GroupingType=998
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
					0 as bitDimension,
					coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
					sum(r.nsize) as nsize, 
					(sum(ps.problem_score_flag*r.nsize*100.0)/sum(r.nsize)) as Score 
				from #questionresults r, qp_comments.dbo.lu_problem_score ps
				where r.qstncore=ps.qstncore and
					r.val=ps.val and
					ps.problem_score_flag in (0,1) and
					bitDelete=0
				group by r.group_id, 
					coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			(sum(ps.problem_score_flag*d.nsize*100.0)/sum(d.nsize)) as Score 
		from #dimensionresults d, qp_comments.dbo.lu_problem_score ps
		where d.qstncore=ps.qstncore and
			d.val=ps.val and
			ps.problem_score_flag in (0,1) and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score	
END
ELSE
BEGIN
	set @sql='insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
				0 as bitDimension,
				coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
				sum(r.nsize) as nsize, 
				(sum(case
						when ' + @offset +' then 1
						else 0
					 end*r.nsize*1.0)/sum(r.nsize))*100 as Score
			from #questionresults r, questionvals q
			where r.qstncore=q.qstncore and
				r.val=q.val and
				scaleorder>0 and
				bitDelete=0
			group by r.group_id, 
				coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			(sum(case
					when ' + @offset +' then 1
					else 0
				 end*d.nsize*1.0)/sum(d.nsize))*100 as Score 
		from #dimensionresults d, questionvals q
		where d.qstncore=q.qstncore and
			d.val=q.val and
			scaleorder>0 and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score'

	exec (@sql)	
END

/*Problem scores and Bottom box scores need to be recoded
  in order to get the right percentiles.  The scores will be changed back
  in a later step */
if @bitReversePercentileScores=1
	update #UnitListScorestemp
	set score=100-score

/*Check the Business Rules*/
	/*Minium # of Units or Facilities*/
if @bitPercentilesType<>1
begin
	delete p
	from #UnitListScorestemp p, 
		(select bitDimension, ID
		 from #UnitListScorestemp
		 group by bitDimension, ID
		 having count(distinct group_id)<10) pl
	where p.bitDimension=pl.bitDimension and
		  p.ID=pl.ID
end
	
	/*Minimum # of Clients*/
	IF @bitMinimumClientCheck=1
	BEGIN
		IF @bitFacility=1
			delete p
			from #UnitListScorestemp p, 
				(select distinct bitDimension, ID
				 from #UnitListScorestemp p, facilityservicesview sf
				 where p.group_id=sf.sufacility_id 
				 group by bitDimension, ID
				 having count(distinct client_id) < 2) pl
			where p.bitDimension=pl.bitDimension and
				  p.ID=pl.ID	
		ELSE 
			delete p
			from #UnitListScorestemp p, 
				(select distinct bitDimension, ID
				 from #UnitListScorestemp p, sampleunit s, clientstudysurvey css
				 where p.group_id=s.sampleunit_id and						s.survey_id=css.survey_id
				 group by bitDimension, ID
				 having count(distinct client_id) < 2) pl
			where p.bitDimension=pl.bitDimension and
				  p.ID=pl.ID
	END

/*Add the unique ID for each record*/
insert into #UnitListScores (group_id, bitDimension, ID, nsize, score)
select group_id, bitDimension, ID, nsize, score
from #UnitListScorestemp
order by bitDimension, ID, score

/*Calculate the Percentile for each score*/
insert into #PercentilesList (group_id, bitDimension, ID, nsize, score, percentile)
select group_id,
		u.bitDimension,
		u.ID,
		nsize,
		score,
		(uniqueID-minUniqueID+1*1.0)/(maxUniqueID-minUniqueID+1)*100
from #UnitListScores U,
	(select bitDimension,			ID,
			min(uniqueID) as minUniqueID,
			max(uniqueID) as maxUniqueID
	from #UnitListScores
	group by bitDimension, ID) m
where u.bitDimension=m.bitDimension and
	  u.ID=m.ID

/*Problem scores and Bottom box scores need to be recoded because they were calculated as 100 - score
  in order to get the right percentiles*/
if @bitReversePercentileScores=1
	update #PercentilesList set score=100-score

if @bitPercentilesType=1 /*list of scores and percentiles*/
BEGIN
	--Create a Lookup Table with unit/Facility Names
	create table #PercentileOwnerLabels (group_id int, Owner varchar(1000))
	IF @bitFacility=1
		insert into #PercentileOwnerLabels
		select distinct group_id, strclient_nm + ' - ' + strfacility_nm + ' (' + convert(varchar,sufacility_id) + ')' as Owner
		from (select distinct group_id
				from #PercentilesList) p, facilityservicesview fs, clientstudysurvey css
		where p.group_id=fs.sufacility_id and
				fs.client_id=css.client_id
	Else
		insert into #PercentileOwnerLabels
		select distinct group_id, 
			strclient_nm + ', ' + strstudy_nm + ', ' + strsurvey_nm  + ', ' + 
			strsampleunit_nm  + ' (' + convert(varchar,sampleunit_id) + ')' as Owner
		from (select distinct group_id
				from #PercentilesList) p, sampleunit s, clientstudysurvey css
		where p.group_id=s.sampleunit_id and
				s.survey_id=css.survey_id	

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

	/*update #PercentilesList
	set percentile=s.percentile
	from #PercentilesList pl, 
		(select ID, score, max(percentile) as percentile
			from #PercentilesList pl
			group by ID, score) s
	where bitDimension=1 and
		pl.ID=s.ID and
		pl.score=s.score*/

	IF @MeasureType=2
	BEGIN
		select  owner,
				'Question' as type,
				p.ID, 
				[Report Text],
				pl.label as Grouping,
				p.nsize,
				score,
				percentile
		from #PercentilesList p, #Labels q, #PercentLabels pl, #PercentileOwnerLabels pol
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=q.qstncore and
				pl.bitDimension=0 and
				p.group_id=pol.group_id
		union all
		select owner,
				'Dimension' as type,
				p.ID, 
				d.strdimension_nm,
				pl.label as Grouping,
				p.nsize,
				score,
				percentile
		from #PercentilesList p, dimensions d, #PercentLabels pl, #PercentileOwnerLabels pol
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=d.dimension_id and
				pl.bitDimension=1 and
				p.group_id=pol.group_id
		order by type, [Report Text], p.percentile
	END
	ELSE
	BEGIN
			select owner,
					'Question' as type,
					p.ID, 
					[Report Text],
					'Mean' as Grouping,
					p.nsize,
					score,
					percentile
			from #PercentilesList p, #Labels q, #PercentileOwnerLabels pol
			where p.ID=q.qstncore and
					p.bitDimension=0 and
					p.group_id=pol.group_id
		union all
			select owner,
					'Dimension' as type,
					p.ID, 
					d.strdimension_nm,
					'Mean' as Grouping,
					p.nsize,
					score,
					percentile
			from #PercentilesList p, dimensions d, #PercentileOwnerLabels pol
			where p.ID=d.dimension_ID and
				  p.bitDimension=1 and
					p.group_id=pol.group_id
		order by type, [Report Text], p.percentile
	END
END
ELSE /*1 to 100 percentiles*/
BEGIN
	if @bitReversePercentileScores=1
	Begin
		insert into #Percentiles1to100
		select p.bitDimension, p.ID, max(p.score) as score,
				pt.percentile
		from #PercentilesList p, percentilesTemp pt
		where p.percentile >=pt.percentile
		group by p.bitDimension, p.ID, pt.percentile

	End
	Else
	Begin
		insert into #Percentiles1to100
		select p.bitDimension, p.ID, min(p.score) as score,
				pt.percentile
		from #PercentilesList p, percentilesTemp pt
		where p.percentile >=pt.percentile
		group by p.bitDimension, p.ID, pt.percentile
	END

	--Fill in any gaps at the bottom of the percentiles
	insert into #Percentiles1to100
	select p.bitDimension, p.ID, p1.score,
			pt.percentile
	from (select bitDimension, ID, min(percentile) as percentile
			from #Percentiles1to100
			group by bitDimension, ID) p, #Percentiles1to100 p1, percentilesTemp pt
	where p.bitDimension=p1.bitDimension and
			p.ID=p1.ID and
			p.percentile=p1.percentile and
			p.percentile >pt.percentile

	IF @MeasureType=2 
	BEGIN
		select 'Question' as type,
				p.ID, 				[Report Text],
				pl.label as Grouping,
				score,
				p.percentile
		from #Percentiles1to100 p, #Labels q, #PercentLabels pl
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=q.qstncore and
				pl.bitDimension=0
		union all
		select 'Dimension' as type,
				p.ID, 
				d.strdimension_nm,
				pl.label as Grouping,
				score,
				p.percentile
		from #Percentiles1to100 p, dimensions d, #PercentLabels pl
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=d.dimension_id and
				pl.bitDimension=1
		order by type, [Report Text], p.percentile desc
	END
	ELSE
	BEGIN
			select 'Question' as type,
					p.ID, 
					[Report Text],
					'Mean' as Grouping,
					score,
					percentile
			from #Percentiles1to100 p, #Labels q
			where p.ID=q.qstncore and
					p.bitDimension=0
		union all
			select 'Dimension' as type,
					p.ID, 
					d.strdimension_nm,
					'Mean' as Grouping,
					score,
					percentile
			from #Percentiles1to100 p, dimensions d
			where p.ID=d.dimension_ID and
				  p.bitDimension=1		
		order by type, [Report Text], p.percentile desc
	END
END

set @Note='Ending SP_NormApp_Percentiles measureType=' + convert(varchar,@measureType) + ', groupingType=' + 
			convert(varchar,@groupingType)
exec sp_normApp_timer 0, @Note


