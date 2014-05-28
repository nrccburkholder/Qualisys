/* This procedure will rollback the sampling of an entire survey. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
create procedure sp_rollback_sampling
	@study_id int,
	@survey_id int = NULL,
	@cascade tinyint = 1
as
	declare @rc int
	declare @sqlstr varchar(8000)

	if @cascade = 1
	begin
		exec @rc = sp_rollback_formgen @study_id, @survey_id, @cascade
		if @@error <> 0 OR @rc <> 0
			return -1
	end

	CREATE TABLE #delsample (
		survey_id int
	)
	CREATE TABLE #popdrop (
		pop_id int
	)

	IF @survey_id IS NULL
	BEGIN
		INSERT INTO #delsample (survey_id)
		SELECT survey_id
		FROM dbo.survey_def
		WHERE study_id = @study_id
		if @@error <> 0
			return -1
	END
	ELSE
	BEGIN
		INSERT INTO #delsample (survey_id) VALUES (@survey_id)
		if @@error <> 0
			return -1
	END

	print 'Getting Sampled Pop Ids to remove for survey.'
	/* Get the pop_ids that are not part of another sample for this study */
	insert into #popdrop
	select distinct sls.pop_id
	from dbo.selectedsample sls, dbo.sampleset ss, #delsample ds
	where sls.sampleset_id = ss.sampleset_id 
	and ss.survey_id = ds.survey_id

	/* We will only remove those population members that are part of a */
	/* different sample set on a survey that we are not deleting */
	delete #popdrop
	from #popdrop pd, dbo.selectedsample sls, dbo.sampleset ss
	where pd.pop_id = sls.pop_id
	and sls.sampleset_id = ss.sampleset_id
	and sls.study_id = @study_id
	and ss.survey_id NOT IN (
		SELECT survey_id FROM #delsample ds
	)
	if @@error <> 0
		return -1

	print 'Rolling back Sampling.'

	BEGIN TRANSACTION

/* This will delete the remaining records that are left in ScheduledMailing that may not
** have been deleted by the FormGen rollback
*/
	print 'Deleting survey from dbo.ScheduledMailing'
	delete dbo.ScheduledMailing
	from dbo.scheduledmailing sm, dbo.samplepop sp, dbo.sampleset ss, #delsample ds
	where sm.samplepop_id = sp.samplepop_id
	and sp.sampleset_id = ss.sampleset_id
	and ss.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.UnitDQ'
	delete dbo.UnitDQ
	from #delsample
	where dbo.UnitDQ.survey_id = #delsample.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.SamplePop'
	delete dbo.SamplePop
	from dbo.samplepop sp, dbo.sampleset ss, #delsample ds
	where sp.sampleset_id = ss.sampleset_id
	and ss.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from Study''s PopFlags'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'PopFlags')
	begin
		set @sqlstr = 'delete S' + convert(varchar(9),@study_id) + '.PopFlags
			from S' + convert(varchar(9),@study_id) + '.PopFlags pf, #popdrop dd
			where pf.pop_id = dd.pop_id'
		exec (@sqlstr)
		if @@error <> 0
		begin
			ROLLBACK TRANSACTION
			return -1
		end
	end

	print 'Deleting survey from Study''s Universe'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'Universe')
	begin
		set @sqlstr = 'delete S' + convert(varchar(9),@study_id) + '.Universe
			from S' + convert(varchar(9),@study_id) + '.Universe un, #popdrop dd
			where un.pop_id = dd.pop_id'
		exec (@sqlstr)
		if @@error <> 0
		begin
			ROLLBACK TRANSACTION
			return -1
		end
	end
	print 'Deleting survey from dbo.SelectedSample'
	delete dbo.SelectedSample
	from dbo.selectedsample sls, dbo.sampleset ss, #delsample ds
	where sls.sampleset_id = ss.sampleset_id
	and ss.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from Study''s UniKeys'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'UniKeys')
	begin
		set @sqlstr = 'delete S' + convert(varchar(9),@study_id) + '.UniKeys
			from S' + convert(varchar(9),@study_id) + '.UniKeys unk, dbo.sampleset ss, #delsample ds
			where unk.sampleset_id = ss.sampleset_id
			and ss.survey_id = ds.survey_id'
		exec (@sqlstr)
		if @@error <> 0
		begin
			ROLLBACK TRANSACTION
			return -1
		end
	end
	print 'Deleting survey from dbo.SampleDataSet'
	delete dbo.SampleDataSet
	from dbo.sampledataset sds, dbo.sampleset ss, #delsample ds
	where sds.sampleset_id = ss.sampleset_id
	and ss.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.SampleSetUnitTarget'
	delete dbo.SampleSetUnitTarget
	from dbo.samplesetunittarget ssut, dbo.sampleset ss, #delsample ds
	where ssut.sampleset_id = ss.sampleset_id
	and ss.survey_id = ds.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.SampleSet'
	delete dbo.SampleSet
	from #delsample
	where dbo.sampleset.survey_id = #delsample.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Deleting survey from dbo.Period'
	delete dbo.Period
	from #delsample
	where dbo.Period.survey_id = #delsample.survey_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		return -1
	end

	print 'Finished rolling back Sampling'
	
	COMMIT TRANSACTION
	DROP TABLE #popdrop
	DROP TABLE #delsample
	return 0


