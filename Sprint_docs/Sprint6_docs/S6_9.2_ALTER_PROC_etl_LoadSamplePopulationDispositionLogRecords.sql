use nrc_datamart
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
		  LEFT JOIN LOAD_TABLES.ResponseBubble ltrb ON lt.QuestionFormID = ltrb.QuestionFormID AND ltrb.responseValue>=0 AND ltrb.DataFileID =  @DataFileID
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

