/*
S18 US20 T1 Rename Then Alter TR_SentMailingdatMailedCAHPS

Hospice CAHPS Calculate Late Mailing	

As an authorized Hospice CAHPS vendor, we need to determine if first mailings are 
beyond the allowed window to mail, so that we do not report them to CMS

sp_helptext tr_SentMailingdatMailedHCAHPS
sp_helptext tr_SentMailingdatMailedCAHPS
sp_helptext QCL_LogDisposition

*/
begin tran

Use [QP_Prod]

EXEC sp_rename 'tr_SentMailingdatMailedHCAHPS', 'tr_SentMailingdatMailedCAHPS'

GO

update Disposition 
set strDispositionLabel = 'CAHPS Mailed Late', strReportLabel = 'CAHPS Mailed Late'
--select * from Disposition
where Disposition_id = 15 
and ((strDispositionLabel = 'HCAHPS Mailed Late') or (strReportLabel = 'HCAHPS Mailed Late'))

GO

ALTER TRIGGER [dbo].[tr_SentMailingdatMailedCAHPS]
ON [dbo].[SENTMAILING]
FOR UPDATE
AS
  IF UPDATE (datMailed)
    BEGIN
      DECLARE @LoggedBy      VARCHAR(50),
              @ReceiptTypeID INT,
              @DispositionID INT,
              @SamplePopID   INT,
              @SentMailID    INT,
              @datLogged     DATETIME
      DECLARE @tbl TABLE (Sentmail_id    INT,
                  Samplepop_id   INT,
                  Disposition_id INT,
                  ReceiptType_id INT,
                  datLogged      DATETIME,
                  LoggedBy       VARCHAR(42))

      INSERT INTO @TBL
                  (Sentmail_id,
                   Samplepop_id,
                   Disposition_id,
                   ReceiptType_id,
                   datLogged,
                   LoggedBy)
      SELECT DISTINCT
             sm.sentmail_id,
             sp.samplepop_id,
             15 AS Dispsition_id,
             0 AS ReceiptType_id,
             GETDATE() AS DatLogged,
             '#nrcsql' AS LoggedBy
      --,datediff(dd,SampleEncounterDate, sm.datmailed) DaysMailedFromEncounter
      FROM   selectedsample ssamp,
             samplepop sp,
             scheduledmailing sc,
             sentmailing sm,
             sampleset ss,
             mailingstep ms,
             sampleunit su,
             INSERTED I
      WHERE  ssamp.sampleset_id = sp.sampleset_id
             AND ssamp.pop_id = sp.pop_id
             AND sp.samplepop_id = sc.samplepop_id
             AND sc.sentmail_id = sm.sentmail_id
             AND sp.sampleset_id = ss.sampleset_id
             AND sc.mailingstep_id = ms.mailingstep_id
             AND ms.bitFirstSurvey = 1
             AND bitSendSurvey = 1
             AND ssamp.sampleunit_id = su.sampleunit_Id
             AND i.sentmail_id = sm.sentmail_id
             AND sm.datmailed IS NOT NULL
             AND ((ss.SurveyType_id = 2  /*HCAHPS*/  AND datediff(dd, SampleEncounterDate, sm.datmailed) > 42) OR
				  (ss.SurveyType_id = 11 /*Hospice*/ AND (Year(sm.datMailed) > Year(DateAdd(mm,3,SampleEncounterDate)) OR
															(Month(sm.datMailed) = (Month(DateAdd(mm,3,SampleEncounterDate))) 
															AND (Day(sm.datMailed) > 7))
														OR (Month(sm.datMailed) > Month(DateAdd(mm,3,SampleEncounterDate))))) OR
				  (ss.SurveyType_id = 12 /*CIHI*/    AND (Year(sm.datMailed) > Year(DateAdd(mm,1,SampleEncounterDate)) OR
				                                          Month(sm.datMailed) > Month(DateAdd(mm,1,SampleEncounterDate)))))
             AND su.CAHPSType_id = ss.SurveyType_Id
             AND sc.OverrideItem_ID IS NULL -- Lee Kohrs 2013-07-17 per HCAHPS2012 Audit TR#6
      ORDER  BY 1 DESC,
                3 DESC

      SELECT TOP 1 @SentmailID = sentmail_id,
                   @SamplePopID = Samplepop_id,
                   @DispositionID = Disposition_id,
                   @ReceiptTypeID = ReceiptType_id,
                   @datLogged = datLogged,
                   @LoggedBy = LoggedBy
      FROM   @tbl

      WHILE @@ROWCOUNT > 0
        BEGIN
          IF NOT EXISTS (SELECT *
                         FROM   DispositionLog
                         WHERE  sentmail_id = @sentmailID
                                AND samplepop_id = @samplepopID
                                AND disposition_id = @DispositionID
                                AND ReceiptType_id = @ReceiptTypeID
                                AND datLogged = @datLogged
                                AND LoggedBy = @LoggedBy)
            EXEC dbo.QCL_LogDisposition
              @SentMailID
              ,@SamplePopID
              ,@DispositionID
              ,@ReceiptTypeID
              ,@LoggedBy
              ,@datLogged

          DELETE FROM @tbl
          WHERE  @sentmailID = sentmail_id
                 AND @SamplePopID = Samplepop_id
                 AND @DispositionID = Disposition_id
                 AND @ReceiptTypeID = ReceiptType_id
                 AND @datLogged = datLogged
                 AND @LoggedBy = LoggedBy

          SELECT TOP 1 @SentmailID = sentmail_id,
                       @SamplePopID = Samplepop_id,
                       @DispositionID = Disposition_id,
                       @ReceiptTypeID = ReceiptType_id,
                       @datLogged = datLogged,
                       @LoggedBy = LoggedBy
          FROM   @tbl
        END
    END 

commit tran