use nrc_datamart
go
update NRC_Datamart.dbo.CahpsDispositionMapping set isDefaultDisposition=0 where cahpsdispositionid=5250 and dispositionid=25
go
alter PROCEDURE [dbo].[etl_LoadSamplePopulationDispositionLogRecords]
	@DataFileID int,
	@DataSourceID int,
    @ProcessDeletes bit
    --,@ReturnMessage As NVarChar(500) Output
AS 
	
   --exec etl_LoadSamplePopulationDispositionLogRecords 2144,1,1
   SET NOCOUNT ON 

	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT, @EntityTypeID INT
	
	SET @EntityTypeID = 7 -- SamplePopulation
	
	--DECLARE @DataSourceID INT
 --   SET @DataSourceID = 1--QPUS

	--DECLARE @DataFileID INT
 --   SET @DataFileID = 876
    
    
	--DECLARE @ProcessDeletes  INT
 --   SET @ProcessDeletes  = 0

 
		--------------------------------------------------------------------------------------
		-- Find ID's for existing records
		--------------------------------------------------------------------------------------
		UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		   SET SamplePopulationID = dsk.DataSourceKeyID
		  FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) on dsk.DataSourceKey = lt.SamplePop_id
		 WHERE lt.DataFileID = @DataFileID
		   AND dsk.DataSourceID = @DataSourceID
		   AND dsk.EntityTypeID = @EntityTypeID	  

        IF @ProcessDeletes = 1 
			BEGIN
			
				UPDATE LOAD_TABLES.SamplePopulationDispositionLog
				 SET isInsert = 0
				   ,isDelete = 1			         
				 FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)
				  INNER JOIN LOAD_TABLES.SamplePopulationDispositionLog ltspdl WITH (NOLOCK)
			   			ON ltsp.id = ltspdl.SamplePop_id
				  WHERE ltsp.isDelete = 1

				 SET @dcnt = @@ROWCOUNT 

			END
        ELSE SET @dcnt = 0

        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
         SET CahpsTypeID  = v.CahpsTypeID
         ,StudyNum = 's' + Cast(v.Study_ID AS NVARCHAR)
		 FROM LOAD_TABLES.SamplePopulationDispositionLog sp WITH (NOLOCK) 
		  INNER JOIN (SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		   ON ss.SamplePopulationID = sp.SamplePopulationID
		  INNER JOIN v_ClientStudySurveySampleUnit v WITH (NOLOCK) ON ss.SampleUnitID = v.SampleUnitID				
		 WHERE sp.DataFileID = @DataFileID AND sp.isDelete = 0

        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		  SET DispositionID = Disposition.DispositionID
		 FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN Disposition WITH (NOLOCK) ON Disposition.DispositionID = lt.Disposition_id
		 WHERE lt.DataFileID = @DataFileID
        
        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		  SET ReceiptTypeID = ReceiptType.ReceiptTypeID
		 FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN dbo.ReceiptType WITH (NOLOCK) ON ReceiptType.ReceiptTypeID = lt.ReceiptType_id
		 WHERE lt.DataFileID = @DataFileID		 
		 	
		 --DECLARE @datLogged DATETIME
	  --   SET @datLogged = ( SELECT FileDateTime FROM ETL.DataFile WHERE datafileid = @DataFileID )  	      		
			
        --NEED TO INSERT ROWS FOR NEW CAHPS QUESTION FORMS only - only if the question form has responses
        --COMPLETE
        INSERT INTO LOAD_TABLES.SamplePopulationDispositionLog
        SELECT DISTINCT lt.DataFileID,lt.Samplepop_id,Mapping.DispositionID,lt.ReceiptTypeID,IsNull(lt.ReturnDate,GETDATE()),'NRC_DataMart Nightly ETL'
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,lt.SamplePopulationID,Mapping.DispositionID,lt.ReceiptTypeID,Survey.CahpsTypeID,'s' + Cast(Survey.Study_ID AS NVARCHAR),1,0 
		--select *
		FROM LOAD_TABLES.QuestionForm lt
		INNER JOIN ( SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		 ON lt.SamplePopulationID = ss.SamplePopulationID
		INNER JOIN SampleUnit su WITH (NOLOCK) ON ss.SampleUnitID = su.SampleUnitID
		INNER JOIN (SELECT SurveyID,CahpsTypeID,Study_ID FROM v_ClientStudySurvey WITH (NOLOCK) WHERE CahpsTypeID > 0) Survey  ON su.SurveyID = Survey.SurveyID
		INNER JOIN (SELECT CahpsTypeID,CahpsDispositionID 
		            From CahpsDisposition WITH (NOLOCK)
		            WHERE CahpsDisposition.IsCahpsDispositionComplete = 1 ) CahpsDisposition 
		  ON Survey.CahpsTypeID = CahpsDisposition.CahpsTypeID
		INNER JOIN CahpsDispositionMapping Mapping WITH (NOLOCK) 		 
		   ON CahpsDisposition.CahpsTypeID = Mapping.CahpsTypeID 
		     AND CahpsDisposition.CahpsDispositionID = Mapping.CahpsDispositionID AND 
		     CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 
		      ELSE lt.ReceiptTypeID  END  = Mapping.ReceiptTypeID 
		 LEFT JOIN  LOAD_TABLES.SamplePopulationDispositionLog ltsapd 
		  ON lt.DataFileID = ltsapd.DataFileID AND lt.SamplePopulationID = ltsapd.SamplePopulationID 
		    AND Mapping.DispositionID = ltsapd.DispositionID AND lt.ReturnDate = ltsapd.datLogged
		  LEFT JOIN LOAD_TABLES.ResponseBubble ltrb ON lt.QuestionFormID = ltrb.QuestionFormID AND ltrb.DataFileID =  @DataFileID
		  LEFT JOIN LOAD_TABLES.ResponseComment ltrc ON lt.QuestionFormID = ltrc.QuestionFormID AND ltrc.DataFileID =  @DataFileID
		WHERE lt.DataFileID = @DataFileID AND lt.isDelete = 0--lt.isInsert = 1 
		AND lt.QuestionFormID IS NOT NULL AND lt.IsComplete = 1 
		AND ltsapd.SamplePopulationID IS NULL--Eliminates dups
	    AND (ltrb.QuestionFormID IS NOT NULL OR ltrc.QuestionFormID IS NOT NULl) -- WE NEED Responses
        UNION ALL--327
       --INCOMPLETE
		 SELECT DISTINCT lt.DataFileID,lt.Samplepop_id,Mapping.DispositionID,lt.ReceiptTypeID,IsNull(lt.ReturnDate,GETDATE()),'NRC_DataMart Nightly ETL'
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0)< 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,lt.SamplePopulationID,Mapping.DispositionID,lt.ReceiptTypeID,Survey.CahpsTypeID,'s' + Cast(Survey.Study_ID AS NVARCHAR),1,0
		--select *
		FROM LOAD_TABLES.QuestionForm lt
		INNER JOIN ( SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		 ON lt.SamplePopulationID = ss.SamplePopulationID
		INNER JOIN SampleUnit su WITH (NOLOCK) ON ss.SampleUnitID = su.SampleUnitID
		INNER JOIN (SELECT SurveyID,CahpsTypeID,Study_ID FROM v_ClientStudySurvey WITH (NOLOCK) WHERE CahpsTypeID > 0) Survey  ON su.SurveyID = Survey.SurveyID
		INNER JOIN (SELECT CahpsTypeID,CahpsDispositionID 
		            From CahpsDisposition WITH (NOLOCK)
		            WHERE CahpsDisposition.IsCahpsDispositionInComplete = 1 ) CahpsDisposition 
		  ON Survey.CahpsTypeID = CahpsDisposition.CahpsTypeID
		INNER JOIN CahpsDispositionMapping Mapping WITH (NOLOCK) 		 
		   ON CahpsDisposition.CahpsTypeID = Mapping.CahpsTypeID 
		     AND CahpsDisposition.CahpsDispositionID = Mapping.CahpsDispositionID AND 
		     CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 --RECEIPTTYPE IS NOT RE
		      ELSE lt.ReceiptTypeID  END  = Mapping.ReceiptTypeID
		 LEFT JOIN LOAD_TABLES.SamplePopulationDispositionLog ltsapd 
		  ON lt.DataFileID = ltsapd.DataFileID AND lt.SamplePopulationID = ltsapd.SamplePopulationID 
		    AND Mapping.DispositionID = ltsapd.DispositionID AND lt.ReturnDate = ltsapd.datLogged    
		  LEFT JOIN LOAD_TABLES.ResponseBubble ltrb ON lt.QuestionFormID = ltrb.QuestionFormID AND ltrb.DataFileID =  @DataFileID
		  LEFT JOIN LOAD_TABLES.ResponseComment ltrc ON lt.QuestionFormID = ltrc.QuestionFormID AND ltrc.DataFileID =  @DataFileID  
		WHERE lt.DataFileID = @DataFileID AND lt.isDelete = 0--lt.isInsert = 1  
		AND lt.QuestionFormID IS NOT NULL AND lt.IsComplete = 0
		AND ltsapd.SamplePopulationID IS NULL--Eliminates dups
		AND (ltrb.QuestionFormID IS NOT NULL OR ltrc.QuestionFormID IS NOT NULl) -- WE NEED Responses
		
		--Special HHCAHPS final disposition logic for question forms where QuestionCore 38694 has a response of 'NO'
		UPDATE spdlt
		SET DispositionID = (SELECT MAX(DispositionID) FROM CahpsDispositionMapping WHERE CahpsTypeID = 2 AND CahpsDispositionID = 220 )
	    --SELECT *
		FROM LOAD_TABLES.SamplePopulationDispositionLog spdlt
		INNER JOIN CahpsDispositionMapping map ON spdlt.DispositionID = map.DispositionID 
		INNER JOIN LOAD_TABLES.QuestionForm qflt ON spdlt.SamplePopulationID = qflt.SamplePopulationID
		INNER JOIN LOAD_TABLES.ResponseBubble rblt ON qflt.QuestionFormID = rblt.QuestionFormID
		WHERE spdlt.DataFileID = @DataFileID AND map.CahpsTypeID = 2 AND map.CahpsDispositionID = 310--Breakoff 
		   AND qflt.DataFileID = @DataFileID AND rblt.DataFileID = @DataFileID
		   AND rblt.nrcQuestionCore = 38694 AND rblt.responseValue <> 1--NO
		   
		--Special MNCMCAHPS final disposition logic for question forms where QuestionCore 39113 has a response of 'NO'   
		UPDATE spdlt
		SET DispositionID = (SELECT MAX(DispositionID) FROM CahpsDispositionMapping WHERE CahpsTypeID = 3 AND CahpsDispositionID = 32 )
	    --SELECT *
		FROM LOAD_TABLES.SamplePopulationDispositionLog spdlt
		INNER JOIN CahpsDispositionMapping map ON spdlt.DispositionID = map.DispositionID 
		INNER JOIN LOAD_TABLES.QuestionForm qflt ON spdlt.SamplePopulationID = qflt.SamplePopulationID
		INNER JOIN LOAD_TABLES.ResponseBubble rblt ON qflt.QuestionFormID = rblt.QuestionFormID
		WHERE spdlt.DataFileID = @DataFileID AND map.CahpsTypeID = 3 AND map.CahpsDispositionID IN (11,12,21,22)--both completed and not completed 
		   AND qflt.DataFileID = @DataFileID AND rblt.DataFileID = @DataFileID
		   AND rblt.nrcQuestionCore = 39113 AND rblt.responseValue <> 1--NO   
		
		INSERT INTO SamplePopulationDispositionLog (SamplePopulationID,DispositionID,LoggedDate,ReceiptTypeID,LoggedBy,DaysFromCurrent,DaysFromFirst,CahpsTypeID)	
		 SELECT DISTINCT lt.SamplePopulationID,lt.DispositionID,lt.datLogged,IsNull(lt.ReceiptTypeID,0),Max(lt.LoggedBy),Max(IsNull(lt.DaysFromCurrent,0))
		 ,Max(IsNull(lt.DaysFromFirst,0)),Max(lt.CahpsTypeID)
		  FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
           LEFT JOIN SamplePopulationDispositionLog spdl WITH (NOLOCK) --CAN'T INSERT A DUP
            ON lt.SamplePopulationID = spdl.SamplePopulationID AND lt.DispositionID = spdl.DispositionID AND lt.datLogged = spdl.LoggedDate 
		  WHERE lt.DataFileID = @DataFileID 
		  AND lt.isDelete = 0 AND spdl.SamplePopulationID IS NULL
            AND lt.SamplePopulationID IS NOT NULL AND lt.DispositionID IS NOT NULL --AND lt.ReceiptTypeID IS NOT NULL   
          GROUP BY lt.SamplePopulationID,lt.DispositionID,lt.datLogged,lt.ReceiptTypeID
  

		SET @icnt = @@ROWCOUNT

        INSERT INTO LOAD_TABLES.SamplePopulationDispositionLogError
         SELECT *,'Required Field Is NULL'
          FROM LOAD_TABLES.SamplePopulationDispositionLog WITH (NOLOCK)
         WHERE DataFileID = @DataFileID AND isDelete = 0
              AND ( SamplePopulationID IS NULL OR DispositionID IS NULL  OR CahpsTypeID IS NULL OR StudyNum IS NULL) --OR ReceiptTypeID IS NULL
    		       
       	SET @ecnt = @@ROWCOUNT	
      
      --------------------------------------------------------------------------------------
	  -- UPDATE SamplePopulation Counts
	   --------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Inserts = @icnt,
			   Updates = 0,
			   Deletes = @dcnt,
               Errors = @ecnt
		  WHERE DataFileID = @DataFileID
			AND Entity = 'SamplePopulationDispositionLog'
			
			--DECLARE @DataFileID INT
			--SET @DataFileID = 708	
	
    
   SET NOCOUNT OFF
go
alter PROCEDURE [dbo].[etl_ProcessSamplePopulationDispositionLogRecords]
	@DataFileID int,
	@DataSourceID int
	--,@ReturnMessage As NVarChar(500) Output
AS 
	
   --exec etl_ProcessSamplePopulationDispositionLogRecords 809,1
   SET NOCOUNT ON 
	
   --DECLARE @DataSourceID INT
   --SET @DataSourceID = 1--QPUS
   
   --DECLARE @DataFileID INT
   --SET @DataFileID = 4
     
     UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsTypeID = v.CahpsTypeID
     ,StudyNum = 's' + CAST(v.Study_ID AS NVARCHAR)
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
     --select *
     FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)
      INNER JOIN CahpsDispositionMapping mapping WITH (NOLOCK) ON ltsp.CahpsTypeID = mapping.CahpsTypeID 
     WHERE ltsp.DataFileID = @DataFileID AND ( ltsp.isInsert = 1 OR CahpsDispositionID_initial = 0)
       AND ltsp.CahpsTypeID > 0
       AND mapping.IsDefaultDisposition = 1         
       
    --Set the CahpsDispositionID for non-Cahps sample pops
    UPDATE LOAD_TABLES.SamplePopulation
     SET CahpsDispositionID_initial = 0
     ,DispositionID = 0
     --select *
     FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)        
     WHERE ltsp.DataFileID = @DataFileID AND ltsp.isInsert = 1
       AND ltsp.CahpsTypeID = 0             
    
	 SELECT lt.SamplePopulationID,lt.DispositionID,CahpsDispositionID,CahpsHierarchy,lt.ReceiptTypeID,lt.CahpsTypeID,lt.StudyNum,lt.SamplePop_id
     INTO #temp
     FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
      INNER JOIN CahpsDispositionMapping mapping WITH (NOLOCK) 
         ON lt.CahpsTypeID = mapping.CahpsTypeID 
           AND lt.DispositionID = mapping.DispositionID
           AND CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 
	               ELSE lt.ReceiptTypeID  
	           END = Mapping.ReceiptTypeID    
       INNER JOIN (SELECT lt.SamplePopulationID,MAX(lt.datLogged) AS datLogged
				   FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
				    INNER JOIN v_CahpsDispositionMapping mapping WITH (NOLOCK) 
				      ON lt.CahpsTypeID = mapping.CahpsTypeID AND lt.DispositionID = mapping.DispositionID
				       AND CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 
										 ELSE lt.ReceiptTypeID  
									   END = Mapping.ReceiptTypeID   
				    INNER JOIN (SELECT SamplePopulationID,MIN(CahpsHierarchy) AS CahpsHierarchy
							    FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
							     INNER JOIN v_CahpsDispositionMapping mapping WITH (NOLOCK) 
							       ON lt.CahpsTypeID = mapping.CahpsTypeID AND lt.DispositionID = mapping.DispositionID
							       AND CASE WHEN Mapping.ReceiptTypeID = -1 THEN  -1 
										 ELSE lt.ReceiptTypeID  
									   END = Mapping.ReceiptTypeID    
							    WHERE lt.DataFileID = @DataFileID--@DataFileID 
							    AND DaysFromFirst <= mapping.NumberCutoffDays AND lt.isDelete = 0
							    GROUP BY SamplePopulationID ) MinCahpsHierarchy 
						 ON lt.SamplePopulationID = MinCahpsHierarchy.SamplePopulationID AND 
						    mapping.CahpsHierarchy = MinCahpsHierarchy.CahpsHierarchy
				  WHERE lt.DataFileID = @DataFileID--@DataFileID 
				  AND DaysFromFirst <=mapping.NumberCutoffDays AND lt.isDelete = 0
				  GROUP BY lt.SamplePopulationID) MaxdatLogged
        ON lt.SamplePopulationID = MaxdatLogged.SamplePopulationID AND lt.datLogged = MaxdatLogged.datLogged
        
      --SELECT * FROM #temp    where SamplePopulationid in (97460771,97462455,97463588,97464134,97465240)      
            
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
     -- SELECT *
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
	  			 --SELECT IsNull(lt.CahpsDispositionID_updated,lt.CahpsDispositionID_initial),*
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
      --select *,CASE WHEN CahpsDisposition.CahpsDispositionID IS NULL THEN 0 ELSE 1 END
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
		 --select *
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