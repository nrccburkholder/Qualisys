/****** Object:  Stored Procedure dbo.sp_Samp_DeDupUnitUnivDyn    Script Date: 9/28/99 2:57:12 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_DeDupUnitUniverse
Part of:  Sampling Tool
Purpose:  This stored procedure randomly eliminates duplicate encounters from the #SampleUnit_Universe table.
Input:  Data contained on #SampleUnit_Universe
 
Output:  Updated #SampleUnit_Universe table
Creation Date: 05/02/2002
Author(s): Dave Gilsdorf
Revision: First build - 05/02/2002
Replaces sp_Samp_DeDupUnitUnivDyn and sp_Samp_DeDupUnitUnivStatic.  Since this is now done after sampling, and the sampling
algorithm implements the rules for static sampling there's no need for separate procedures for dynamic and static sampling.
That is, we don't need to pick a random encounter for people in units they didn't get sampled in.
***********************************************************************************************************************************/
CREATE PROCEDURE dbo.sp_Samp_DeDupUnitUniverse
AS
 CREATE TABLE #Dup_GroupedSampleUnitPop
 	(SampleUnit_id INT, 
	Pop_id INT)

 /* Identifies the duplicate records from the sampleUnit Universe */
 INSERT INTO #Dup_GroupedSampleUnitPop
 SELECT SampleUnit_id, Pop_id
 FROM #SampleUnit_Universe
 WHERE strUnitSelectType in ('D','I')
 GROUP BY SampleUnit_id, Pop_id
 HAVING COUNT(*) > 1
 
 if @@rowcount > 0 
 BEGIN
	-- if a survey doesn't have an encounter table the INSERT INTO #Dup_GroupedSampleUnitPop command wouldn't have
	-- done anything, so the rest of the code can assume there's an encounter table present.

	CREATE TABLE #Dup_SampleUnit_Pop
		(Dup_SampleUnit_Pop_id int identity(1,1),
		SampleUnit_id INT, 
		Pop_id INT, 
		Enc_id INT)
	CREATE INDEX idxSamplePop
		ON #Dup_SampleUnit_Pop(SampleUnit_id, Pop_id)

	CREATE TABLE #Dup_Pop_Enc
		(Dup_Pop_Enc_id int identity(1,1),
		Pop_id INT, 
		Enc_id INT,
		strUnitSelectType char(1),
		intRandom INT)
	CREATE INDEX idxPopEnc
		ON #Dup_Pop_Enc (Pop_id, Enc_id)

	/* pull all records from sampleunit universe for anyone with one or more duplicate records per sample unit */
	/* one record per sample unit */
	INSERT INTO #Dup_SampleUnit_Pop (sampleunit_id, pop_id)
	SELECT distinct suu.SampleUnit_id, suu.Pop_id  
	FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP
	WHERE strUnitSelectType in ('D','I')
	and suu.pop_id = DGSUP.pop_id 

	/* one record per encounter */
	INSERT INTO #Dup_Pop_Enc (pop_id, enc_id, strUnitSelectType)
	SELECT suu.Pop_id, suu.Enc_id, min(strUnitSelectType)
	FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP
	WHERE strUnitSelectType in ('D','I')
	and suu.pop_id = DGSUP.pop_id 
	GROUP BY suu.Pop_id, suu.Enc_id

	/* pick an arbitrary point in the RandomNumber table and update #Dup_Pop_Enc with intRandomNumber's
	starting there.  Add @RandomTableSize to intRandomNumber for encounters that were only indirectly 
	sampled so the encounters with direct sample will get first dibs. */
	declare @RandomStart int, @RandomTableSize int
	select @RandomTableSize = count(*) from RandomNumber
	set @RandomStart = floor(rand() * @RandomTableSize)

	update DPE
	set intRandom = intRandomNumber + case when DPE.strUnitSelectType = 'I' then @RandomTableSize else 0 end
	from #Dup_Pop_Enc DPE, RandomNumber RN
	where (DPE.Dup_Pop_Enc_id + @RandomStart) % @RandomTableSize = RN.RandomNumber_id

	/* pick the encounters used to represent each Pop in their sample units */
	declare @rowsleft int
	set @rowsleft=1
	while @rowsleft > 0 
	begin
		/* take each pop's minimum random number and use the associated encounter in every unit it's in 
		(except for units that already have an encounter assigned to them)     */
		update dsup
		set dsup.enc_id=pe.enc_id
		from #Dup_SampleUnit_Pop dsup, #SampleUnit_Universe suu, #Dup_Pop_Enc pe, 
			(select pop_id,min(intRandom) as intRandom
			 from #Dup_Pop_Enc 
			 group by pop_id) sub
		where pe.pop_id= sub.pop_id and pe.intRandom=sub.intRandom
		and pe.pop_id= suu.pop_id and pe.enc_id=suu.enc_id
		and pe.pop_id=dsup.pop_id and suu.sampleunit_id=dsup.sampleunit_id
		and dsup.enc_id is null

		/* delete each pop's minumum random number record */
		delete pe
		from #Dup_Pop_Enc pe, 
			(select pop_id,min(intRandom) as intRandom
			from #Dup_Pop_Enc 
			group by pop_id) sub
		where pe.pop_id=sub.pop_id and pe.intRandom=sub.intRandom

		/* repeat until you've gone through all encounters */
		select @rowsleft = count(*) from #Dup_Pop_Enc 
	end

	/* Updates #SampleUnit_Universe with the removed_rule flag set to 5 for all duplicate encounters */
	UPDATE SUU
	SET Removed_Rule = 5
	FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop DSUP
	WHERE SUU.SampleUnit_id = DSUP.sampleUnit_id
	AND SUU.Pop_id = DSUP.Pop_id
	and SUU.Removed_rule = 0

	/* Updates #SampleUnit_Universe with the removed_rule flag set back to 0 for those encounters we want to keep */
	UPDATE SUU
	SET Removed_Rule = 0
	FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop DSUP
	WHERE SUU.SampleUnit_id = DSUP.sampleUnit_id
	AND SUU.Pop_id = DSUP.Pop_id
	AND SUU.Enc_id = DSUP.Enc_id
	and SUU.Removed_rule = 5

	/* updates #SampleUnit_Universe - sets strUnitSelectType back to 'N' */
	UPDATE SUU
	SET strUnitSelectType = 'N'
	FROM #SampleUnit_Universe SUU
	WHERE SUU.Removed_rule = 5

	DROP TABLE #Dup_Pop_Enc
	DROP TABLE #Dup_SampleUnit_Pop
 END

 DROP TABLE #Dup_GroupedSampleUnitPop


