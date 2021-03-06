/****** Object:  StoredProcedure [dbo].[spBatchSurvey]    Script Date: 08/09/2006 12:58:31 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spBatchSurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spBatchSurvey]
GO
/****** Object:  StoredProcedure [dbo].[spBatchSurvey]    Script Date: 08/09/2006 12:58:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spBatchSurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE spBatchSurvey @respondent_id int,  @batch_id int, @max_batch_size int AS
BEGIN TRAN
   DECLARE @batch_size int

   IF @batch_id IS NULL
      BEGIN

         SET @batch_id = (SELECT ISNULL(MAX(BatchID),0) + 1 FROM Respondents)
         
      END

   ELSE 
      BEGIN

         SET @batch_size = (SELECT COUNT(BatchID) FROM Respondents WHERE BatchID = @batch_id)

         IF @batch_size >= @max_batch_size
            BEGIN

               SET @batch_id = (SELECT ISNULL(MAX(BatchID),0) + 1 FROM Respondents)

            END

      END

      UPDATE Respondents SET BatchID = @batch_id WHERE (RespondentID = @respondent_id)
      SELECT BatchID = @batch_id

COMMIT TRAN
' 
END
GO
