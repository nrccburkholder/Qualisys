/*
s20 US8 T1 Changes to ICH Dispositions	

3/11/2015 Chris Burkholder

Changes to ICH Dispositions	Change ICH Dispositions as requried by CMS.	Details will be provided by Dana

8.1	Update ETL_ProcessSamplePopulationDispositionLogRecords SP in Catalyst

From the following document:
http://workspaces.nationalresearch.com/PE/PMO/Projects/ALL%20CAHPS/Business%20Analysis/_Sprint20/ICH_DispoChanges_Spring2015.docx

EXEC sp_helptext 'dbo.etl_ProcessSamplePopulationDispositionLogRecords'

*/

use [NRC_Datamart]
GO

ALTER PROCEDURE [dbo].[etl_ProcessSamplePopulationDispositionLogRecords]
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


GO