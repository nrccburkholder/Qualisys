set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_Samp_UpdateSelectedSample    Script Date: 9/28/99 2:57:19 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_UpdateSelectedSample
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - Brian Dohmen - 7/7/2003
  UPDATE SamplePlanWorkSheet table
***********************************************************************************************************************************/
ALTER  PROCEDURE [dbo].[sp_Samp_UpdateSelectedSample]
 @intSampleSet_id INT,
 @enc_exists bit
AS

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_UpdateSelectedSample', getdate())
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 DECLARE @intStudy_id INT, @intSurvey_id INT, @sql varchar(2000), @ReportField VARCHAR(100)
 DECLARE @Table VARCHAR(42), @CutOffCode INT, @SampleDate DATETIME
 /*Fetch the Study id*/
 SELECT @intStudy_id=SD.Study_id, @intSurvey_id=ss.Survey_id, @CutOffCode=strCutOffResponse_cd,
        @SampleDate=datSampleCreate_dt
  FROM dbo.Survey_def SD, dbo.SampleSet SS
  WHERE SD.Survey_id=SS.Survey_id
   AND SS.SampleSet_id=@intSampleSet_id

IF @CutOffCode=2
 SELECT @ReportField=strField_nm, @Table=strTable_nm
 FROM Survey_Def sd, MetaField mf, MetaTable mt
 WHERE sd.CutOffField_id=mf.Field_id
 AND sd.CutOffTable_id=mt.Table_id
 AND sd.Survey_id=@intSurvey_id
 
 --Check for duplicate pops sampled for the same unit
 IF EXISTS (select sampleunit_id, pop_id
			from #SampleUnit_Universe
			where strUnitSelectType <> 'N'
			group by sampleunit_id, pop_id
			having count(*)>1)
BEGIN
	
	RAISERROR ('Duplicate records sampled for the same unit for the same pop_id.  Please delete this sample and try sampling again.  If this error happens again, please sumbit a helpdesk ticket.', 18, 1)
	Return
END
--Check for a failure sampling up the tree
ELSE IF EXISTS (select top 1 x.pop_id
				from #SampleUnit_Universe x join sampleunittreeindex suti
					on x.sampleunit_id=suti.sampleunit_id and
						x.strunitselecttype='D'
					left join #SampleUnit_Universe y
					on y.sampleunit_id=suti.ancestorunit_id and
					  x.pop_id=y.pop_id and
					  y.strunitselecttype in ('D','I')
				where y.sampleunit_id is null)
BEGIN
	RAISERROR ('Error Sampling up the tree.  Please delete this sample and try sampling again.  If this error happens again, please sumbit a helpdesk ticket.', 18, 1)
	Return
END
ELSE
BEGIN
 	/* Add the Records to SelectedSample*/
	IF @enc_exists=1 
	BEGIN
		--IF this isn't dynamic SQL, an error is thrown claiming that enc_id doesn't exist
		--Not sure why, but it has to be this way
		SET @SQL='INSERT INTO dbo.SelectedSample
				  (SampleSet_id, Study_id, Pop_id, SampleUnit_id, strUnitSelectType, enc_id, sampleEncounterDate, reportDate)
				  	SELECT ' + convert(varchar,@intSampleSet_id) + ', ' +
					convert(varchar,@intStudy_id) + ', SUU.Pop_id, SUU.SampleUnit_id, SUU.strUnitSelectType, SUU.enc_id, encDate, reportDate
				   FROM #SampleUnit_Universe SUU
				   WHERE SUU.strUnitSelectType <> ''N'''
		EXEC (@SQL)
	END
	ELSE
	BEGIN
	 INSERT INTO dbo.SelectedSample
	  (SampleSet_id, Study_id, Pop_id, SampleUnit_id, strUnitSelectType, sampleEncounterDate, reportDate)
	  SELECT @intSampleSet_id, @intStudy_id, SUU.Pop_id, SUU.SampleUnit_id, SUU.strUnitSelectType, encDate, reportDate
	   FROM #SampleUnit_Universe SUU
	   WHERE SUU.strUnitSelectType <> 'N'
	END
END

--Verify they are Sampled all the way up the tree.
--EXEC sp_temp_InsertParents_by_SampleSet @intSampleSet_id,@intStudy_id

--Update SamplePlanWorkSheet table
CREATE TABLE #SampleCount (SampleSet_id INT, SampleUnit_id INT, SampleCount INT, IndirectSampleCount int, DQ INT, Avail INT/*, DQAdd INT, DQAge INT*/)

/*DECLARE @DQAdd INT, @DQAge INT

SET @DQAdd = (SELECT TOP 1 BusinessRule_id 
	FROM BusinessRule br, CriteriaStmt c
	WHERE Survey_id = @intSurvey_id
	AND br.CriteriaStmt_id = c.CriteriaStmt_id
	AND c.strCriteriaStmt_nm = 'DQ_AddEr')

SET @DQAge = (SELECT TOP 1 BusinessRule_id 
	FROM BusinessRule br, CriteriaStmt c
	WHERE Survey_id = @intSurvey_id
	AND br.CriteriaStmt_id = c.CriteriaStmt_id
	AND c.strCriteriaStmt_nm = 'DQ_Age')*/

INSERT INTO #SampleCount 
SELECT @intSampleSet_id, 
	SampleUnit_id, 
	SUM(CASE strUnitSelectType WHEN 'D' THEN 1 ELSE 0 END), 
	SUM(CASE strUnitSelectType WHEN 'I' THEN 1 ELSE 0 END), 
	SUM(CASE WHEN DQ_Bus_Rule =0 THEN 0 ELSE 1 END),
	SUM(CASE WHEN REMOVED_RULE =0 THEN 1 ELSE 0 END)/*, 
	SUM(CASE DQ_Bus_Rule WHEN @DQAdd THEN 1 ELSE 0 END), 
	SUM(CASE DQ_Bus_Rule WHEN @DQAge THEN 1 ELSE 0 END)*/
FROM #SampleUnit_Universe
GROUP BY SampleUnit_id

UPDATE spw
SET spw.intSampledNow = SampleCount,
	spw.intIndirectSampledNow=IndirectSampleCount, 
	intDQ = DQ, 
	intAvailableUniverse = Avail, 
	--intDQAdd = DQAdd, 
	--intDQAge = DQAge,
	intUniversecount=DQ + Avail,
	intshortfall=intoutgoneedednow-SampleCount
FROM SamplePlanWorkSheet spw, #SampleCount t
WHERE spw.SampleUnit_id = t.SampleUnit_id
AND spw.SampleSet_id = t.SampleSet_id

CREATE Table #MinMax (sampleunit_id int, minencdate datetime, maxencdate datetime)

Insert into #MinMax
SELECT sampleunit_id, min(EncDate), max(EncDate)
FROM #Sampleunit_universe
WHERE Strunitselecttype in ('I','D')
group by sampleunit_id


UPDATE SamplePlanWorkSheet
SET minEnc_dt=minencdate,
	maxEnc_dt=maxencdate
FROM #MinMax m,SamplePlanWorkSheet s
where s.sampleset_id=@intSampleSet_id 
	and m.sampleunit_id=s.sampleunit_id

EXECUTE SP_SAMP_SPWDQ_COUNTS @intsampleset_id, @intsurvey_id

DROP TABLE #SampleCount

--Update ReportDate in SelectedSample for the sampleset if sampled date is the report date
IF @CutOffCode=0
 UPDATE SelectedSample
 SET ReportDate=@SampleDate
 WHERE SampleSet_id=@intSampleSet_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED





