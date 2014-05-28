CREATE PROCEDURE SP_Dedup_CommentsForExtract  
AS   
  
SELECT Cmnt_ID, count(*) as countit  
into #Dup_CmntIDs  
FROM comments_for_extract        
group by Cmnt_ID  
having count(*) > 1  
  
if @@rowcount > 0  
begin   
 select distinct ss.SampleSet_ID  
 into #AllSampleSets  
 from comments_for_extract ce, samplepop sp, selectedsample ss  
 where sp.SamplePop_ID = ce.samplepop_ID and  
      sp.pop_ID = ss.pop_ID and  
    ce.Study_ID = ss.Study_ID and  
    ce.cmnt_ID in (select cmnt_Id from #Dup_CmntIDs)  
  
  
 declare @TotalExtractedNum int  
 declare @TotalPopID int  
 declare @SampleSet_ID int  
 declare @bitShouldUpdate bit  
  
 set @bitShouldUpdate = 0  
  
 DECLARE myCursor CURSOR FOR   
 SELECT SampleSet_ID FROM #AllSampleSets   
  
 OPEN myCursor  
 FETCH NEXT FROM myCursor   
 INTO @SampleSet_ID  
  
 WHILE @@FETCH_STATUS = 0  
  BEGIN  
print @SampleSet_ID  
   --get the Total number of records that are marked with an intextracted_flg = 1  
   select @TotalExtractedNum = count(*)   
   from selectedsample   
   where sampleset_ID = @SampleSet_ID   
   and intExtracted_Flg = 1  
      
   select @TotalPopID = count(distinct pop_ID)   
   from selectedsample   
   where sampleset_ID = @SampleSet_ID   
  
   if @TotalExtractedNum <> @TotalPopID  
    BEGIN  
     print 'Extract and Pop count did not match'  
     set @bitShouldUpdate = 1  
  
     select distinct pop_ID, count(*) as countit  
     into #tmpPop_ID  
     from selectedsample  
     where sampleset_ID = @SampleSet_ID  and intExtracted_Flg = 1  
     group by pop_ID  
     having count(*) > 1  
  
     --This is the actual updated code here.  
     update selectedsample set intExtracted_Flg = null where sampleset_ID = @SampleSet_ID   
     and intExtracted_Flg = 1  
     and pop_ID in (select pop_ID from #tmpPop_ID)  
print 'rowcount = ' + cast(@@rowcount as varchar)  
     drop table #tmpPop_ID  
  
    END  
  
   FETCH NEXT FROM myCursor   
   INTO @SampleSet_ID  
  
  END  
  
 CLOSE myCursor  
 DEALLOCATE myCursor  

print 'end of proc, before final step'

 --run this  after update to reset the intExtracted_flg from null to what it should be.  
 if @bitShouldUpdate = 1  
  begin

		DECLARE @LastSampleSet INT, @FirstSampleSet INT  
		SELECT @LastSampleSet=MAX(sampleset_id) FROM SampleSet WHERE datSampleCreate_dt < DATEADD(hh,-1,GETDATE())  
		SELECT @FirstSampleSet=MAX(SampleSet_id) FROM SampleSet WHERE datSampleCreate_dt<DATEADD(dd,-3,GETDATE())  
		    
		INSERT INTO ReportingHierarchy (Survey_ID, Study_ID, intTier, Reporting_Level_nm)    
		  SELECT sd.Survey_ID, sd.Study_ID, 1, 'Level 1'    
		  FROM SampleUnit su, SamplePlan sp, Survey_Def sd    
		  WHERE su.ParentSampleUnit_ID IS NULL    
			AND su.Reporting_Hierarchy_ID IS NULL    
			AND su.SamplePlan_ID=sp.SamplePlan_ID    
			AND sp.Survey_ID=sd.Survey_ID    
		    
		IF @@ROWCOUNT > 0     
		BEGIN    
		  UPDATE su    
		  SET Reporting_Hierarchy_ID=rh.Reporting_Hierarchy_ID    
		  FROM ReportingHierarchy rh, SampleUnit su, SamplePlan sp, Survey_Def sd    
		  WHERE su.ParentSampleUnit_ID IS NULL    
			AND su.Reporting_Hierarchy_ID IS NULL    
			AND su.SamplePlan_ID=sp.SamplePlan_ID    
			AND sp.Survey_ID=sd.Survey_ID    
			AND sd.Survey_ID=rh.Survey_ID    
		END    
		    
		SELECT TOP 1 * FROM SampleUnit WHERE Reporting_Hierarchy_ID IS NULL    
		WHILE @@ROWCOUNT > 0     
		BEGIN    
		  UPDATE suc    
		  set Reporting_Hierarchy_ID=rhc.Reporting_Hierarchy_ID    
		  FROM SampleUnit suc, SampleUnit sup, ReportingHierarchy rhp, ReportingHierarchy rhc    
		  WHERE suc.Reporting_Hierarchy_ID IS NULL    
			AND suc.ParentSampleUnit_ID=sup.SampleUnit_ID    
			AND sup.Reporting_Hierarchy_ID=rhp.Reporting_Hierarchy_ID    
			AND rhp.Reporting_Hierarchy_ID=rhc.Prnt_Reporting_Hierarchy_ID    
		    
		  INSERT INTO ReportingHierarchy (Survey_ID,Study_ID,intTier,Reporting_Level_nm,Prnt_Reporting_Hierarchy_ID)    
		  SELECT DISTINCT rhp.Survey_ID,rhp.Study_ID,rhp.intTier+1 intTier,'Level '+CONVERT(VARCHAR,rhp.intTier+1) Reporting_Level_nm,rhp.Reporting_Hierarchy_ID Prnt_Reporting_Hierarchy_ID    
		  FROM SampleUnit suc, SampleUnit sup, ReportingHierarchy rhp    
		  WHERE suc.Reporting_Hierarchy_ID IS NULL    
			AND suc.ParentSampleUnit_ID=sup.SampleUnit_ID    
			AND sup.Reporting_Hierarchy_ID=rhp.Reporting_Hierarchy_ID    
		END    
		    
		CREATE TABLE #SampleUnitTier (SamplePlan_ID INT, SampleUnit_ID INT, intTier INT)    
		    
		INSERT INTO #SampleUnitTier (SamplePlan_ID, SampleUnit_ID, intTier)    
		  SELECT su.SamplePlan_ID, su.SampleUnit_ID, rh.intTier    
		  FROM SampleUnit su, ReportingHierarchy rh    
		  WHERE su.Reporting_Hierarchy_ID=rh.Reporting_Hierarchy_ID    
		    
		SELECT ss.Pop_ID, ss.Study_ID, ss.SampleSet_ID, ss.SampleUnit_ID, SUT.intTier    
		INTO #PopTier    
		FROM SELECTedSample ss, #SampleUnitTier SUT    
		WHERE ss.SampleUnit_ID=SUT.SampleUnit_ID     
		  AND ss.strUnitSELECTType='D'    
		  AND ss.intExtracted_flg IS NULL    
		-- 4/20/06 (BD/SS) Restrict scope of samplesets evaluated (< 3days old AND > 1 hour old)    
		--   AND ss.sampleset_id > (SELECT MAX(sampleset_id) FROM SampleSet WHERE datSampleCreate_dt < DATEADD(dd,-3,GETDATE()))    
		--   AND ss.sampleset_id < (SELECT MAX(sampleset_id) FROM SampleSet WHERE datSampleCreate_dt < DATEADD(hh,-1,GETDATE()))    
		  AND ss.SampleSet_id BETWEEN @FirstSampleSet AND @LastSampleSet  
		DROP TABLE #SampleUnitTier    
		    
		SELECT PT.Pop_ID, PT.Study_ID, pt.SampleSet_ID, PT.SampleUnit_ID, PT.intTier, CONVERT(FLOAT,-1) RandNum    
		INTO #PopMaxTier    
		FROM #PopTier PT,    
		  (SELECT Pop_ID, Study_ID, SampleSet_ID, MAX(intTier) maxTier    
		  FROM #PopTier    
		  GROUP BY Pop_ID, Study_ID, SampleSet_ID) Sub    
		WHERE PT.Pop_ID=Sub.Pop_ID    
		  AND PT.Study_ID=Sub.Study_ID    
		  AND PT.SampleSet_ID=Sub.SampleSet_ID    
		  AND PT.intTier=Sub.maxTier    
		DROP TABLE #PopTier    
		    
		SELECT Pop_ID, pmt.Study_ID, pmt.SampleSet_ID   
		INTO #Dup   
		FROM #PopMaxTier pmt, sampleset ss, Survey_def sd    
		WHERE pmt.sampleset_id=ss.sampleset_id    
		AND ss.Survey_id=sd.Survey_id    
		--BD 12/14/1 Duplicates are not isolated to dynamic Surveys    
		--AND sd.bitdynamic = 0     
		GROUP BY Pop_ID, pmt.Study_ID, pmt.SampleSet_ID   
		HAVING COUNT(*)>1    
		CREATE INDEX #Dupindex ON #Dup (Pop_ID, Study_ID, SampleSet_ID)    
		CREATE INDEX #PMTindex ON #PopMaxTier (Pop_ID, Study_ID, SampleSet_ID)    
		    
		DECLARE @Pop_ID INT, @Study_ID INT, @SampleSet_ID2 INT, @SampleUnit_ID INT    
		    
		SET NOCOUNT ON    
		DECLARE curPMT CURSOR FOR     
		  SELECT PMT.Pop_ID, PMT.Study_ID, PMT.SampleSet_ID, SampleUnit_ID    
		  FROM #PopMaxTier PMT, #Dup    
		  WHERE PMT.Pop_ID = #Dup.Pop_ID    
			AND PMT.Study_ID = #Dup.Study_ID    
			AND PMT.SampleSet_ID = #Dup.SampleSet_ID    
		OPEN curPMT    
		FETCH NEXT FROM curPMT INTO @Pop_ID, @Study_ID, @SampleSet_ID2, @SampleUnit_ID    
		WHILE @@FETCH_STATUS = 0    
		BEGIN    
		  UPDATE #PopMaxTier SET RandNum=rand() WHERE Pop_ID=@Pop_ID AND Study_ID=@Study_ID AND SampleSet_ID=@SampleSet_ID2 AND SampleUnit_ID=@SampleUnit_ID    
		  FETCH NEXT FROM curPMT INTO @Pop_ID, @Study_ID, @SampleSet_ID2, @SampleUnit_ID     
		END    
		CLOSE curPMT    
		DEALLOCATE curPMT    
		SET NOCOUNT OFF    
		DROP TABLE #Dup    
		    
		UPDATE PMT    
		SET RandNum=-1    
		FROM #PopMaxTier PMT,     
		  (SELECT Pop_ID,Study_ID,SampleSet_ID,MIN(RandNum) RandNum    
		  FROM #PopMaxTier     
		  GROUP BY Pop_ID,Study_ID,SampleSet_ID) Sub    
		WHERE PMT.Pop_ID=Sub.Pop_ID    
		  AND PMT.Study_ID=Sub.Study_ID    
		  AND PMT.SampleSet_ID=Sub.SampleSet_ID    
		  AND PMT.RandNum=Sub.RandNum    
		    
		UPDATE ss    
		SET intExtracted_flg=1    
		FROM SELECTedSample ss, #PopMaxTier PMT    
		WHERE ss.Pop_ID=pmt.Pop_ID    
		  AND ss.Study_ID=pmt.Study_ID    
		  AND ss.SampleSet_ID=pmt.SampleSet_ID    
		  AND ss.SampleUnit_ID=pmt.SampleUnit_ID    
		  AND pmt.RandNum=-1    
		DROP TABLE #PopMaxTier    
		    
		UPDATE SELECTedSample     
		SET intExtracted_flg=0     
		WHERE intExtracted_flg IS NULL    
		  AND SampleSet_ID<=@LastSampleSet    
	end
end


