use NRC_Datamart
go
update NRC_Datamart.dbo.CahpsDispositionMapping set isDefaultDisposition=1 where cahpsdispositionid=5250 and dispositionid=25
go
CREATE PROCEDURE [dbo].[etl_ProcessSamplePopulationDispositionLogRecords]
	@DataFileID int,
	@DataSourceID int
	--,@ReturnMessage As NVarChar(500) Output
AS 
   --exec etl_ProcessSamplePopulationDispositionLogRecords 809,1
   SET NOCOUNT ON 
	
   --DECLARE @DataSourceID INT
   --SET @DataSourceID = 1--QPUS
   
   --DECLARE @DataFileID INT
   --SET @DataFileID = 16

     UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsTypeID = v.CahpsTypeID
     ,StudyNum = 's' + CAST(v.Study_ID AS NVARCHAR)
     -- select sp.datafileid,sp.id as samplepop_id,v.cahpstypeid, v.study_id
	 FROM LOAD_TABLES.SamplePopulation sp WITH (NOLOCK)
	  INNER Join ( SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID 
	               FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
	    ON ss.SamplePopulationID = sp.SamplePopulationID           
	  INNER JOIN dbo.v_ClientStudySurveySampleUnit v WITH (NOLOCK) ON ss.SampleUnitID = v.SampleUnitID
	 WHERE sp.DataFileID = @DataFileID AND sp.isDelete = 0

    --Set the default CahpsDispositionID for NEW sample pops added
    UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsDispositionID_initial = mapping.CahpsDispositionID
     ,DispositionID = mapping.DispositionID
     --select ltsp.datafileid, ltsp.id as samplepop_id, mapping.CahpsDispositionID, mapping.DispositionID
     FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)
      INNER JOIN CahpsDispositionMapping mapping WITH (NOLOCK) ON ltsp.CahpsTypeID = mapping.CahpsTypeID 
     WHERE ltsp.DataFileID = @DataFileID AND ( ltsp.isInsert = 1 OR CahpsDispositionID_initial = 0)
       AND ltsp.CahpsTypeID > 0
       AND mapping.IsDefaultDisposition = 1         

       
    --Set the CahpsDispositionID for non-Cahps sample pops
    UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsDispositionID_initial = 0
     ,DispositionID = 0
     --select ltsp.datafileid, ltsp.id
     FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)        
     WHERE ltsp.DataFileID = @DataFileID AND ltsp.isInsert = 1
       AND ltsp.CahpsTypeID = 0;
    
	with CTE_SampPopDisp (DataFileID, SamplePopulationID, CahpsHierarchy, datLogged)
	as
	(
		SELECT lt.DataFileID, SamplePopulationID,CahpsHierarchy,MAX(lt.datLogged) AS datLogged
		FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
		INNER JOIN v_CahpsDispositionMapping mapping WITH (NOLOCK) 
				ON lt.CahpsTypeID = mapping.CahpsTypeID 
				  AND lt.DispositionID = mapping.DispositionID
				  AND CASE WHEN Mapping.ReceiptTypeID = -1 THEN  -1 ELSE lt.ReceiptTypeID END = Mapping.ReceiptTypeID    
		WHERE lt.DataFileID = @DataFileID
		AND DaysFromFirst <= mapping.NumberCutoffDays AND lt.isDelete = 0
		GROUP BY lt.DataFileID, SamplePopulationID,CahpsHierarchy
	)
	SELECT lt.SamplePopulationID,lt.DispositionID,CahpsDispositionID,CahpsHierarchy,lt.ReceiptTypeID,lt.CahpsTypeID,lt.StudyNum,lt.SamplePop_id
    INTO #temp
    FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
      INNER JOIN CahpsDispositionMapping mapping WITH (NOLOCK) 
         ON lt.CahpsTypeID = mapping.CahpsTypeID 
           AND lt.DispositionID = mapping.DispositionID
           AND CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 ELSE lt.ReceiptTypeID END = Mapping.ReceiptTypeID    
       INNER JOIN (	select L.SamplePopulationID, max(L.datLogged) as datLogged
					from CTE_SampPopDisp L
					inner join (select SamplePopulationID, MIN(CahpsHierarchy) AS CahpsHierarchy
								from CTE_SampPopDisp 
								group by SamplePopulationID) H
						on l.SamplePopulationID=h.SamplePopulationID and l.CahpsHierarchy=h.CahpsHierarchy
					group by L.SamplePopulationID) MaxdatLogged
        ON lt.SamplePopulationID = MaxdatLogged.SamplePopulationID AND lt.datLogged = MaxdatLogged.datLogged
        
    --SELECT * FROM #temp    where SamplePop_id in (100509536)      

	if exists (select * from #temp where CahpsTypeID=5) -- ICH-CAHPS
	begin
		declare @eligibilityOverride table (Q1 int, Q2 int, Q3to44Answers int, AnyAnswers int, DispositionOverride int, CahpsDispositionOverride int)
		insert into @eligibilityOverride values (-9,-9,0,1,32,5130)	-- [blank] (-9) / [blank] (-9)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (-9,1,0,1,8,5160)	-- [blank] (-9) / < 3 months (1)								--> Ineligible: Does Not Meet Eligibility Criteria
																	-- [blank] (-9) / 3 months+ (2-4*)								--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (-9,5,0,1,34,5190)	-- [blank] (-9) / No longer at this facility (5)				--> Ineligible: No Longer Receiving Care at Sampled Facility
		insert into @eligibilityOverride values (1,-9,0,1,8,5160)	-- At home (1) / [blank] (-9)									--> Ineligible: Does Not Meet Eligibility Criteria
		insert into @eligibilityOverride values (1,1,0,1,32,5130)	-- At home (1) / < 3 months (1)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,2,0,1,32,5130)	-- At home (1) / 3-12 months (2)								--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,3,0,1,32,5130)	-- At home (1) / 1-5 years (3)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,4,0,1,32,5130)	-- At home (1) / 5 years + (4)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,5,0,1,32,5130)	-- At home (1) / No longer at this facility (5)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
																	-- At the dialysis ctr (2) / [blank] (-9)						--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (2,1,0,1,8,5160)	-- At the dialysis ctr (2) / < 3 months (1)						--> Ineligible: Does Not Meet Eligibility Criteria
																	-- At the dialysis ctr (2) / 3 months+ (2-4*)					--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (2,5,0,1,34,5190)	-- At the dialysis ctr (2) / No longer at this facility (5)		--> Ineligible: No Longer Receiving Care at Sampled Facility
		insert into @eligibilityOverride values (3,-9,0,1,33,5140)	-- Do not currently rec'v (3) / [blank] (-9)					--> Ineligible: Not Receiving Dialysis
		insert into @eligibilityOverride values (3,1,0,1,32,5130)	-- Do not currently rec'v (3) / < 3 months (1)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,2,0,1,32,5130)	-- Do not currently rec'v (3) / 3-12 months (2)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,3,0,1,32,5130)	-- Do not currently rec'v (3) / 1-5 years (3)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,4,0,1,32,5130)	-- Do not currently rec'v (3) / 5 years+ (4)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,5,0,1,32,5130)	-- Do not currently rec'v (3) / No longer at this facility (5)	--> Completed Mail Questionnaire—Survey Eligibility Unknown
				
		insert into @eligibilityOverride values (-9,-9,1,1,32,5130)	-- [blank] (-9) / [blank] (-9)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (-9,1,1,1,32,5130)	-- [blank] (-9) / < 3 months (1)								--> Completed Mail Questionnaire—Survey Eligibility Unknown
																	-- [blank] (-9) / 3 months+ (2-4*)								--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (-9,5,1,1,32,5130)	-- [blank] (-9) / No longer at this facility (5)				--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,-9,1,1,32,5130)	-- At home (1) / [blank] (-9)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,1,1,1,32,5130)	-- At home (1) / < 3 months (1)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,2,1,1,32,5130)	-- At home (1) / 3-12 months (2)								--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,3,1,1,32,5130)	-- At home (1) / 1-5 years (3)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,4,1,1,32,5130)	-- At home (1) / 5 years+ (4)									--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (1,5,1,1,32,5130)	-- At home (1) / No longer at this facility (5)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
																	-- At the dialysis ctr (2) / [blank] (-9)						--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (2,1,1,1,32,5130)	-- At the dialysis ctr (2) / < 3 months (1)						--> Completed Mail Questionnaire—Survey Eligibility Unknown
																	-- At the dialysis ctr (2) / 3 months+ (2-4*)					--> No override - use original heirarchical disposition
		insert into @eligibilityOverride values (2,5,1,1,32,5130)	-- At the dialysis ctr (2) / No longer at this facility (5)		--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,-9,1,1,32,5130)	-- Do not currently rec'v (3) / [blank] (-9)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,1,1,1,32,5130)	-- Do not currently rec'v (3) / < 3 months (1)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,2,1,1,32,5130)	-- Do not currently rec'v (3) / 3-12 months (2)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,3,1,1,32,5130)	-- Do not currently rec'v (3) / 1-5 years (3)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,4,1,1,32,5130)	-- Do not currently rec'v (3) / 5 years+ (4)					--> Completed Mail Questionnaire—Survey Eligibility Unknown
		insert into @eligibilityOverride values (3,5,1,1,32,5130)	-- Do not currently rec'v (3) / No longer at this facility (5)	--> Completed Mail Questionnaire—Survey Eligibility Unknown

		declare @override table (SamplepopulationID int, DispositionOverride int, CahpsDispositionOverride int)
		insert into @override
		select SamplepopulationID, DispositionOverride, CahpsDispositionOverride
		from (select qf.samplepopulationid
				, max(	case when masterquestioncore =51198 then 
							case when responsevalue < 0 then -9 else responsevalue end -- recode anything less than zero to -9, so it'll join with @eligibilityOverride 
						else 
							-9 
						end) as Q1
				, max(	case when masterquestioncore =51199 then 
							case when responsevalue < 0 then -9 else responsevalue end -- recode anything less than zero to -9, so it'll join with @eligibilityOverride 
						else 
							-9 
						end) as Q2
				, max(case when masterquestioncore in (	47159,47160,47161,47162,47163,47164,47165,47166,47167,47168,47169,47170,47171,47172,47173,47174,47175,
														47176,47177,47178,47179,47180,47181,47182,47183,47184,47185,47186,47187,47188,47189,47190,47191,47192,
														47193,47194,47195,47196,47197,47198,47199,47200) 
												and responsevalue >= 0 then 
								1 
							else 
								0 
							end) as Q3to44Answers
				, max(case when responsevalue >= 0 then 
								1 
							else 
								0 
							end) as AnyAnswers
			from #temp t
			inner join load_tables.questionform qf on t.SamplePopulationID=qf.SamplePopulationID	
			inner join load_tables.responsebubble rb on rb.QuestionFormID=qf.QuestionFormID
			where t.CahpsTypeID=5
			--and rb.masterquestioncore in (51198,51199, -- Q1, Q2 (respectively)
			--								47159,47160,47161,47162,47163,47164,47165,47166,47167,47168,47169,47170,47171,47172,47173,47174,47175,
			--								47176,47177,47178,47179,47180,47181,47182,47183,47184,47185,47186,47187,47188,47189,47190,47191,47192,
			--								47193,47194,47195,47196,47197,47198,47199,47200) --Q3-44
			group by qf.samplepopulationid) r
		inner join @eligibilityOverride eo on r.q1=eo.q1 and r.q2=eo.q2 and r.Q3to44Answers=eo.Q3to44Answers and r.AnyAnswers=eo.AnyAnswers
		
		update t set CahpsDispositionID=o.CahpsDispositionOverride, DispositionID=o.DispositionOverride, CahpsHierarchy=0
		from @override o
		inner join #temp t on o.samplepopulationid=t.samplepopulationid
			
		delete from @override
		
		-- inserting disposition records for returned surveys into #temp, so the 'insert into @override' query (below) works properly
		insert into #temp
		select distinct t.samplepopulationID
			, 1234 as DispositionID			-- using 1234 as a disposition code for 'returned'. We're not sure what mode was returned, but for the zombie
			, 1234 as CahpsDispositionID	-- analysis, we don't care. All we care about is whether there's a returned survey or not.
			, 5 as CahpsHierarchy
			, t.receipttypeID
			, t.CahpsTypeID
			, t.StudyNum
			, t.SamplePop_id
		from #temp t
		inner join load_tables.questionform qf on t.samplepopulationid=qf.samplepopulationid
		where qf.returndate is not null

		
		declare @zombie table (bitReturned bit, bitProxy bit, bitDead bit, DispositionOverride int, CahpsDispositionOverride int, bitIncludeResponses bit)
		insert into @zombie values (1,1,0,35,5199,1)
		insert into @zombie values (1,1,1, 3,5150,0)
		insert into @zombie values (0,0,1, 3,5150,0)

		insert into @override
		select SamplePopulationID, z.DispositionOverride, z.CahpsDispositionOverride 
		from (	select t.SamplePopulationID
				, max(case when t.dispositionid = 1234 then 1 else 0 end) as bitReturned
				, max(case when masterquestioncore =47214 and responsevalue = 3 then 1 else 0 end) as bitProxy 
				, max(case when t.dispositionid in (3) then 1 else 0 end) as bitDead
				from #temp t
				inner join load_tables.questionform qf on t.SamplePopulationID=qf.SamplePopulationID	
				LEFT OUTER join load_tables.responsebubble rb on rb.QuestionFormID=qf.QuestionFormID AND rb.masterquestioncore in (47214)
				where t.dispositionid in (3,1234)
				and t.CahpsTypeID=5
				group by t.SamplePopulationID) r
		inner join @zombie z on r.bitReturned=z.bitReturned and r.bitDead=z.bitDead and r.bitProxy=z.bitProxy

		delete from #temp where DispositionID=1234

		update t set CahpsDispositionID=o.CahpsDispositionOverride, DispositionID=o.DispositionOverride, CahpsHierarchy=0
		--select o.samplepopulationid, t.CahpsDispositionID, o.CahpsDispositionOverride, t.DispositionID, o.DispositionOverride, t.CahpsHierarchy, 0
		from @override o
		inner join #temp t on o.samplepopulationid=t.samplepopulationid
	end

    --THE BELOW CODE GETS RIDS OF DUPS IF A SAMPLE POP HAS MULTIPLE ROWS FOR A DISTICNT datLogged   
    SELECT #temp.SamplePopulationID,min(#temp.CahpsTypeID)AS CahpsTypeID,min(#temp.CahpsHierarchy)AS CahpsHierarchy
           ,min(#temp.SamplePop_id) AS SamplePop_id,min(#temp.CahpsDispositionID) AS CahpsDispositionID,min(#temp.DispositionID) AS DispositionID
           ,min(StudyNum) AS StudyNum
    INTO #temp2     
	FROM #temp
	INNER JOIN (SELECT SamplePopulationID,MIN(CahpsHierarchy) AS CahpsHierarchy--*
				FROM #temp
				GROUP BY SamplePopulationID )temp on #temp.SamplePopulationID = temp.SamplePopulationID and #temp.CahpsHierarchy = temp.CahpsHierarchy
	GROUP BY #temp.SamplePopulationID    
	
	DROP TABLE #temp
	--select * from #temp2  where SamplePopulationid in (97460771,97462455,97463588,97464134,97465240)
	
	CREATE INDEX IX_SamplePop ON #temp2 (SamplePopulationID)
	        
      --insert rows for sample popS that need to updated becuase rows in the disposition log        
     INSERT INTO LOAD_TABLES.SamplePopulation (DataFileID,id,SamplePopulationID,SampleSetID,CahpsTypeID,StudyNum,CahpsDispositionID_initial,isInsert,isDelete,sampleset_id,DispositionID)
     SELECT DISTINCT @DataFileID,temp.SamplePop_id,temp.SamplePopulationID,SamplePopulation.SampleSetID
         ,temp.CahpsTypeID,temp.StudyNum
         ,CASE WHEN SamplePopulation.CahpsDispositionID = 0 THEN mapping.CahpsDispositionID ELSE SamplePopulation.CahpsDispositionID END AS CahpsDispositionID                         
         ,0,0,-99
         ,CASE WHEN SamplePopulation.DispositionID = 0 THEN mapping.DispositionID ELSE SamplePopulation.DispositionID END AS DispositionID       
        --SELECT *
      FROM #temp2 temp
        INNER JOIN SamplePopulation WITH (NOLOCK) ON temp.SamplePopulationID = SamplePopulation.SamplePopulationID
        LEFT JOIN (SELECT CahpsTypeID,Max(DispositionID) AS DispositionID,Max(CahpsDispositionID) AS CahpsDispositionID
					FROM CahpsDispositionMapping mapping WITH (NOLOCK) 
					WHERE mapping.IsDefaultDisposition = 1
					GROUP BY mapping.CahpsTypeID ) AS mapping ON temp.CahpsTypeID = mapping.CahpsTypeID
        LEFT JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON temp.SamplePopulationID = lt.SamplePopulationID AND lt.DataFileID = @DataFileID
      WHERE lt.SamplePopulationID IS NULL 
      --and SamplePopulation.DispositionID  = 0
      --AND temp.SamplePopulationid in (97460771,97462455,97463588,97464134,97465240)
      
     UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsDispositionID_updated = temp.CahpsDispositionID
     ,DispositionID_updated = temp.DispositionID
     -- ,IsCahpsDispositionComplete = CahpsDisposition.IsCahpsDispositionComplete
     -- SELECT lt.DataFileID, lt.SamplePopulationID, lt.CahpsTypeID, lt.DispositionID, temp.CahpsHierarchy, mapping.CahpsHierarchy, temp.CahpsDispositionID, temp.DispositionID
     FROM #temp2 temp
      INNER JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON temp.SamplePopulationID = lt.SamplePopulationID
      INNER JOIN (SELECT CahpsTypeID,DispositionID,MIN(CahpsHierarchy)CahpsHierarchy 
                  FROM CahpsDispositionMapping mapping WITH (NOLOCK) 
                  GROUP BY mapping.CahpsTypeID,mapping.DispositionID) mapping
        ON lt.CahpsTypeID = mapping.CahpsTypeID      
         AND lt.DispositionID = mapping.DispositionID  
          --ON lt.CahpsDispositionID_initial = mapping.CahpsDispositionID          
      WHERE lt.DataFileID = @DataFileID
      AND temp.CahpsHierarchy <= mapping.CahpsHierarchy 
       --and  temp.SamplePopulationid in (97460771,97462455,97463588,97464134,97465240)       
          
      DROP TABLE #temp2   	 
  			  
	 --For Cahps complete dispositions, verify that the sample pop's question form is complete  
	  SELECT lt.SamplePopulationID--,*
      INTO #temp3
      FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
       INNER JOIN (SELECT CahpsDispositionID 
                   FROM CahpsDisposition WITH (NOLOCK) 
                   WHERE IsCahpsDispositionComplete = 1) CahpsDisposition 
           ON IsNull(lt.CahpsDispositionID_updated,lt.CahpsDispositionID_initial)= CahpsDisposition.CahpsDispositionID
        LEFT JOIN QuestionForm qf WITH (NOLOCK) ON lt.SamplePopulationID = qf.SamplePopulationID AND qf.IsActive = 1 
	  WHERE lt.DataFileID = @DataFileID AND (qf.SamplePopulationID IS NULL OR qf.IsCahpsComplete <> 1 )
   
	  UPDATE SamplePopulation
	  SET CahpsDispositionID = IsNull(lt.CahpsDispositionID_updated,lt.CahpsDispositionID_initial)
	  ,DispositionID = IsNull(lt.DispositionID_updated,lt.DispositionID)
	  			 --SELECT distinct SamplePopulation.SamplePopulationID, IsNull(lt.CahpsDispositionID_updated,lt.CahpsDispositionID_initial), IsNull(lt.DispositionID_updated,lt.DispositionID)
	  FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
	   INNER JOIN SamplePopulation WITH (NOLOCK) ON lt.SamplePopulationID = SamplePopulation.SamplePopulationID
	   LEFT JOIN #temp3 temp ON lt.SamplePopulationID = temp.SamplePopulationID -- EXCLUDE SAMPLE POPs with incomplete question forms
	  WHERE lt.DataFileID = @DataFileID 
	   AND lt.CahpsTypeID > 0 AND temp.SamplePopulationID IS NULL
	   AND ( IsNull(lt.CahpsDispositionID_updated,lt.CahpsDispositionID_initial) <> SamplePopulation.CahpsDispositionID 
	    OR  IsNull(lt.DispositionID_updated,lt.DispositionID) <> SamplePopulation.DispositionID )
	     --and SamplePopulation.SamplePopulationid in (97460771,97462455,97463588,97464134,97465240)     
		 -- ,IsCahpsDispositionComplete = CahpsDisposition.IsCahpsDispositionComplete

     DROP TABLE #temp3   
	   
	 UPDATE SamplePopulation
      SET IsCahpsDispositionComplete = CASE WHEN CahpsDisposition.CahpsDispositionID IS NULL THEN 0 ELSE 1 END 
      --select sp.SamplePopulationID, CASE WHEN CahpsDisposition.CahpsDispositionID IS NULL THEN 0 ELSE 1 END
      FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)
       INNER Join SamplePopulation sp WITH (NOLOCK) ON ltsp.SamplePopulationID = sp.SamplePopulationID
       LEFT JOIN (SELECT CahpsDispositionID 
                  FROM CahpsDisposition WITH (NOLOCK) 
                  WHERE IsCahpsDispositionComplete = 1) CahpsDisposition ON sp.CahpsDispositionID = CahpsDisposition.CahpsDispositionID
	  WHERE ltsp.DataFileID = @DataFileID        		  
   
	 --per 5/26 email from Mike, not updating
	 -- UPDATE SamplePopulation
	 --  SET DispositionID = lt.DispositionID
	 -- --SELECT SamplePopulation.SamplePopulationID,lt.SamplePopulationID,lt.DispositionID
		--FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)          
		--  INNER JOIN (SELECT lt.SamplePopulationID,MAX(lt.datLogged) AS datLogged
		--			   FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
		--			   WHERE lt.DataFileID = @DataFileID AND lt.isDelete = 0
		--			   GROUP BY lt.SamplePopulationID) MaxdatLogged
		--	ON lt.SamplePopulationID = MaxdatLogged.SamplePopulationID AND lt.datLogged = MaxdatLogged.datLogged
		--   INNER JOIN SamplePopulation WITH (NOLOCK) ON lt.SamplePopulationID = SamplePopulation.SamplePopulationID 
		-- WHERE SamplePopulation.DispositionID <> lt.DispositionID  
		 
		  --For debugging/error resolution purposes, will populate the initial CshpsDispositionID for rows that were updated
		 UPDATE lt
		 SET cahpsDispositionID_initial = CahpsDispositionID 
		 --select lt.SamplePopulationID, cahpsDispositionID_initial, cahpstypeid, isInsert, IsDelete, CahpsDispositionID 
		 FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
		 INNER JOIN SamplePopulation sp WITH (NOLOCK) ON lt.SamplePopulationID = sp.SamplePopulationID
		 WHERE DataFileID = @DataFileID 
		  AND cahpsDispositionID_initial = 0 AND cahpstypeid <>  0 AND isInsert = 0 AND IsDelete = 0     
		 
		INSERT INTO [LOAD_TABLES].[SamplePopulationDispositionLog_Cumulative]
		SELECT *
		FROM [LOAD_TABLES].[SamplePopulationDispositionLog] WITH (NOLOCK)
		WHERE DataFileID = @DataFileID		
				
		INSERT INTO [LOAD_TABLES].[SamplePopulation_Cumulative]
		SELECT [DataFileID],[id],[sampleset_id],[SamplePopulationID],[SampleSetID],[CahpsTypeID]
         ,[StudyNum],[CahpsDispositionID_initial],[CahpsDispositionID_updated],[isInsert],[isDelete]
		FROM [LOAD_TABLES].[SamplePopulation] WITH (NOLOCK)
		WHERE DataFileID = @DataFileID      	
						
       SET NOCOUNT OFF
go