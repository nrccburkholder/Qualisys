CREATE PROCEDURE dbo.sp_pcl_commentloc_check_errors
as
if object_id('tempdb..#NeededCommentBoxes') is not null
	drop table #NeededCommentBoxes

SELECT distinct pqf.*, sp.samplepop_id, sq.language as sqlang, sq.section_id, sq.qstncore, sq.height
into #NeededCommentBoxes
FROM qp_scan..pclquestionform pqf
inner join questionform qf on pqf.questionform_id=qf.questionform_id
inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
inner join samplepop sp on scm.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join sampleunitsection sus on ss.sampleunit_id=sus.sampleunit_id
inner join sel_qstns sq on sus.SELQSTNSSECTION=sq.sectioN_id and sus.SELQSTNSSURVEY_ID=sq.survey_id 
WHERE  sq.subtype=4 -- comment box
and sq.height>0 -- this is the number of blank lines pclgen puts after the comment question. Zero-line comments are more like instructions for the respondent

-- for some reason, the query was slowed down considerably when I added "and pqf.language=sq.language" to the sel_qstns join. 
-- So I left it off and am just deleting non-matching rows here:
delete from #NeededCommentBoxes
where language<>sqlang

if object_id('tempdb..#PCLGenPosError ') is not null
	drop table #PCLGenPosError 

CREATE TABLE #PCLGenPosError (
	[batch_id] [int] NULL,
	[sql_error] [int] NULL,
	[returned_error] [int] NULL,
	[isResolved] [tinyint] NULL default 0,
	[datgenerated] [datetime] NULL default getdate(),
	[Samplepop_id] [int] NULL,
	[QuestionForm_id] [int] NULL
	)

declare @now datetime
set @now=getdate()

-- SQL_Error=1 : forms that have fewer records in CommenLoc than they shoud
insert into #PCLGenPosError (batch_id, samplepop_id, questionform_id, sql_error, returned_error, isResolved, datgenerated)
select needed.batch_id, needed.samplepop_id, needed.questionform_id, 1 as SQL_Error, 0 as returned_error, 0 as isResolved, @now as datGenerated
--, needed.survey_id, needed.questionform_id, needed.numCommentBox as neededCommentbox
--, exist.numCommentBox as existingCommentBox
--, case when isnull(needed.numCommentbox,0) <> isnull(exist.numCommentBox,0) then 'problem' else 'ok' end as status
from (      select survey_id, batch_id, samplepop_id, questionform_id, count(*) as numCommentBox
            from #NeededCommentBoxes
            group by survey_id, batch_id, samplepop_id, questionform_id ) needed
left outer join 
      (     select questionform_id, count(distinct selqstns_id) as numCommentBox
            from qp_scan.dbo.commentloc
            where questionform_id in (select questionform_id from #NeededCommentBoxes)
            group by questionform_id ) exist
on needed.questionform_id=exist.questionform_id
where isnull(needed.numcommentbox,0) <> isnull(exist.numcommentbox,0)

if @@RowCount>0
begin
	-- SQL_Error=2 : forms that have the correct number of CommenLoc records, but that have the same survey_id as forms that have SQL_Error=2
	-- we want to 'error' these forms out too, so they don't get sent to Queue Manager
	insert into #PCLGenPosError (batch_id, samplepop_id, questionform_id, sql_error, returned_error, isResolved, datgenerated)
	select pqf.batch_id, qf.samplepop_id, pqf.questionform_id, 2 as SQL_Error, 0 as returned_error, 0 as isResolved, @now as datGenerated
	from qp_scan.dbo.pclquestionform pqf
	inner join questionform qf on pqf.questionform_id=qf.questionform_id
	where pqf.survey_id in (select survey_id
						from #PCLGenPosError err
						inner join qp_scan.dbo.pclquestionform pqf on pqf.questionform_id=err.questionform_id
						where err.datgenerated=@now)
	and pqf.questionform_id not in (select questionform_id
								from #PCLGenPosError err
								where err.datgenerated=@now)
	
	-- remove anything from the temp table that's already in the permanent error table
	delete t
	from #PCLGenPosError t
	inner join PCLGenPosError p on t.questionform_id=p.questionform_id
	where p.isresolved=0
	
	-- populate the permanent error table
	insert into PCLGenPosError (batch_id, samplepop_id, questionform_id, sql_error, returned_error, isResolved, datgenerated)
	select batch_id, samplepop_id, questionform_id, sql_error, returned_error, isResolved, datgenerated
	from #PCLGenPosError
end